import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/matches/models/ball_outcome.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/current_player.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/providers/extras_provider.dart';

class MatchStateNotifier extends StateNotifier<Match?> {
  MatchStateNotifier(super.state);

  //* Returns the current innings (if second innings has started, use that).
  Inning? get currentInnings {
    if (state == null) return null;
    return state!.inning2 ?? state!.inning1;
  }

  //* Creates a new match with the provided configuration.
  Future<void> createMatch({
    required MatchTeamInfo team1,
    required MatchTeamInfo team2,
    required List<MatchPlayerInfo> team1Players,
    required List<MatchPlayerInfo> team2Players,
    required MatchFormat matchFormat,
    required MatchType matchType,
    required String venue,
    required DateTime schedule,
    required int noOfPlayer,
  }) async {
    state = Match(
      team1: team1,
      team2: team2,
      team1Players: team1Players,
      team2Players: team2Players,
      matchFormat: matchFormat,
      matchType: matchType,
      venue: venue,
      schedule: schedule,
      noOfPlayer: noOfPlayer,
      currentBatsmen: [],
      strikerIndex: 0,
      currentBowlers: null,
    );
  }

  //* Sets the toss result and decision.
  void setTossResult(bool isTeam1Won, TossDecision decision) {
    if (state == null) return;

    state = state!.copyWith(
      isTeam1WonToss: isTeam1Won,
      tossDecision: decision,
    );
  }

  //* Starts the first innings.
  void startFirstInnings() {
    if (state == null) return;

    state = state!.initializeFirstInnings();
  }

  //* Starts the second innings.
  void startSecondInnings() {
    if (state == null) return;

    state = state!.initializeSecondInnings();
  }

  //* Updates the striker (and optionally the non-striker) data.
  void updateStrikers({
    required int strikerIndex,
    List<StrikerData>? batsmen,
  }) {
    if (state == null) return;

    state = state!.copyWith(
      strikerIndex: strikerIndex,
      currentBatsmen: batsmen ?? state!.currentBatsmen,
    );
  }

  //* Updates the striker's score.
  //* This method is called only when the batsman should be credited
  //* (i.e. not for wides or byes/leg byes or a no-ball with byes/leg byes).
  void _updateStrikerScore({
    required int runs,
    required bool isWicket,
    required ExtrasState extras,
    String? outBatsmanId,
  }) {
    if (state == null || state!.currentBatsmen == null) return;

    final strikerIndex = state!.strikerIndex;

    //* Wicket handling:
    if (isWicket) {
      //* If the striker is out (or for run-outs affecting the non-striker)
      if (outBatsmanId == null ||
          outBatsmanId == state!.currentBatsmen![strikerIndex].id) {
        final updatedStriker =
            state!.currentBatsmen![strikerIndex].wicket(runs, !extras.isWide);

        final updatedMatchPlayer = state!.getBattingTeamPlayers().map((player) {
          if (player.playerId == updatedStriker.id) {
            return player.copyWith(battingStatus: BattingStatus.out);
          }
          return player;
        }).toList();

        state = state!.copyWith(
          currentBatsmen: state!.currentBatsmen!.map((batsman) {
            if (batsman.id == updatedStriker.id) return updatedStriker;
            return batsman;
          }).toList(),
          team1Players: state!.battingTeam.teamId == state!.team1.teamId
              ? updatedMatchPlayer
              : state!.team1Players,
          team2Players: state!.battingTeam.teamId == state!.team2.teamId
              ? updatedMatchPlayer
              : state!.team2Players,
        );
      } else {
        //* Non-striker gets dismissed (commonly in a run-out).
        final updatedNonStriker =
            state!.currentBatsmen![(strikerIndex + 1) % 2].wicket(0, false);

        final updatedStriker =
            state!.currentBatsmen![strikerIndex].addRuns(runs);
        state = state!.copyWith(
          currentBatsmen: state!.currentBatsmen!.map((batsman) {
            if (batsman.id == updatedStriker.id) return updatedStriker;
            if (batsman.id == updatedNonStriker.id) return updatedNonStriker;
            return batsman;
          }).toList(),
        );
      }

      return;
    }

    //* Add runs only if the delivery is not “extra” (i.e. wide, bye, leg bye,
    //* or a no-ball that resulted in bye/leg bye).
    final shouldAddRuns = !(extras.isWide ||
        extras.isBye ||
        extras.isLegBye ||
        (extras.isNoBall && (extras.isBye || extras.isLegBye)));
    if (shouldAddRuns) {
      final updatedStriker = state!.currentBatsmen![strikerIndex].addRuns(runs);
      state = state!.copyWith(
        currentBatsmen: state!.currentBatsmen!.map((batsman) {
          if (batsman.id == updatedStriker.id) return updatedStriker;
          return batsman;
        }).toList(),
      );
    }

    //* Change strike if the batsmen ran an odd number of runs.
    final int newStrikerIndex =
        (runs % 2 != 0) ? (state!.strikerIndex + 1) % 2 : state!.strikerIndex;
    updateStrikers(strikerIndex: newStrikerIndex);
  }

  //? Updates the bowler's statistics based on the delivery outcome.
  //* **Logic:**
  //* - **Wide:** Bowler is charged 1 run (penalty) plus any additional runs
  //*   (e.g. if the batsmen ran extra).
  //* - **No-Ball:** Always 1 penalty run. If the batsman hit the ball (i.e. it’s
  //*   not accompanied by byes/leg byes) add his runs; if byes/leg byes are involved,
  //*   only the penalty run is charged.
  //* - **Byes/Leg Byes:** No runs are charged to the bowler.
  //* - **Legal Delivery:** Add runs scored off the bat.
  void _updateBowlerScore({
    required int runs,
    required bool isWicket,
    required ExtrasState extras,
  }) {
    if (state == null || state!.currentBowlers == null) return;
    int runsForBowler = 0;
    if (extras.isWide) {
      runsForBowler = 1 + runs;
    } else if (extras.isNoBall) {
      if (extras.isBye || extras.isLegBye) {
        runsForBowler = 1;
      } else {
        runsForBowler = 1 + runs;
      }
    } else if (extras.isBye || extras.isLegBye) {
      runsForBowler = 0;
    } else {
      runsForBowler = runs;
    }

    final updatedBowlingStats = state!.currentBowlers!.addBall(
      runs: runsForBowler,
      isWide: extras.isWide,
      isNoBall: extras.isNoBall,
      isWicket: isWicket,
    );

    state = state!.copyWith(currentBowler: updatedBowlingStats);
  }

  //* Changes the bowler.
  void changeBowler(CurrentBowlerData? bowler) {
    if (state == null) return;
    state = state!.copyWith(currentBowler: bowler);
  }

  //* Updates the batting statistics for a given batsman.
  void updateBattingScore({
    required String batsmanId,
    required int runs,
    required bool isFour,
    required bool isSix,
    required int ballsFaced,
  }) {
    if (currentInnings == null) return;
    final battingStats = currentInnings!.battingStats;
    final batsmanIndex =
        battingStats.indexWhere((stats) => stats.uuid == batsmanId);

    if (batsmanIndex == -1) return;

    final updatedBattingStats = List<BattingScore>.from(battingStats);
    updatedBattingStats[batsmanIndex] = battingStats[batsmanIndex].copyWith(
      runs: (battingStats[batsmanIndex].runs ?? 0) + runs,
      ballsFaced: (battingStats[batsmanIndex].ballsFaced ?? 0) + ballsFaced,
      fours: isFour
          ? (battingStats[batsmanIndex].fours ?? 0) + 1
          : battingStats[batsmanIndex].fours,
      sixes: isSix
          ? (battingStats[batsmanIndex].sixes ?? 0) + 1
          : battingStats[batsmanIndex].sixes,
    );

    _updateInnings(battingStats: updatedBattingStats);
  }

  //* Updates the bowling statistics for a given bowler.
  //* (This method can be used for manual adjustments.)
  void updateBowlingScore({
    required String bowlerId,
    required int runs,
    required bool isWide,
    required bool isNoBall,
    required bool isWicket,
    required bool isDot,
  }) {
    if (currentInnings == null) return;

    final bowlingStats = currentInnings!.bowlingStats;
    final bowlerIndex =
        bowlingStats.indexWhere((stats) => stats.uuid == bowlerId);

    if (bowlerIndex == -1) return;

    final updatedBowlingStats = List<BowlingScore>.from(bowlingStats);
    updatedBowlingStats[bowlerIndex] = bowlingStats[bowlerIndex].addBall(
      runs: runs,
      isWide: isWide,
      isNoBall: isNoBall,
      isWicket: isWicket,
    );

    //* Check for a maiden over (last 6 legal balls with 0 runs).
    if (_isCompletedOver(updatedBowlingStats[bowlerIndex].balls) &&
        _isLastOverMaiden(bowlerId)) {
      updatedBowlingStats[bowlerIndex] =
          updatedBowlingStats[bowlerIndex].addMaidenOver();
    }

    _updateInnings(bowlingStats: updatedBowlingStats);
  }

  //* Adds a delivery outcome.
  //*
  //* This method applies the full cricket scoring rules:
  //* - **Team Score:** Includes penalty extras (e.g. 1 run for a no-ball or wide)
  //*   plus any additional runs scored.
  //* - **Batsman:** Only credited if the delivery is not “extra” (except a no-ball
  //*   where the batsman hits the ball).
  //* - **Bowler:** Charged based on the type of extra (byes/leg byes aren’t counted).
  //* - **Wicket:** Dismissals on a no-ball are disallowed (except run outs).
  void addDelivery({
    required int runs,
    required bool isFour,
    required bool isSix,
    required ExtrasState extras,
    bool isWicket = false,
    String? outBatsman,
    ReasonOfOut? reasonOfOut,
  }) {
    if (currentInnings == null) return;

    //* In a no-ball delivery (except run outs), dismissals are not allowed.
    if (extras.isNoBall && isWicket && (reasonOfOut != ReasonOfOut.runOut)) {
      isWicket = false;
    }

    //* Calculate the total team runs for this delivery.
    //* - For a wide: 1 (penalty) + any additional runs (from running).
    //* - For a no-ball: 1 (penalty) + batsman’s runs (if valid shot) or, if accompanied
    //*   by byes/leg byes, only the penalty is charged to the bowler (though the team
    //*   score includes the extra runs).
    //* - For byes/leg byes: team runs equal the runs taken.
    int totalTeamRuns = 0;
    if (extras.isWide) {
      totalTeamRuns = 1 + runs;
    } else if (extras.isNoBall) {
      totalTeamRuns = 1 + runs;
    } else if (extras.isBye || extras.isLegBye) {
      totalTeamRuns = runs;
    } else {
      totalTeamRuns = runs;
    }

    //* Update the current innings with this delivery.
    final updatedInnings = currentInnings!.addDelivery(
      runs: totalTeamRuns,
      isFour: isFour,
      isSix: isSix,
      isWide: extras.isWide,
      isNoBall: extras.isNoBall,
      isBye: extras.isBye,
      isLegBye: extras.isLegBye,
      isWicket: isWicket,
    );

    _updateCurrentInnings(updatedInnings);

    // Determine the type of delivery.
    BallType ballType = BallType.valid;
    if (extras.isWide) {
      ballType = BallType.wide;
    } else if (extras.isNoBall) {
      ballType = BallType.noBall;
    } else if (extras.isBye) {
      ballType = BallType.bye;
    } else if (extras.isLegBye) {
      ballType = BallType.legBye;
    }

    final ballOutcome = BallOutcome(
      type: ballType,
      runs: runs,
      isWicket: isWicket,
      reasonOfOut: reasonOfOut,
    );

    //* For an extra (wide or no-ball), the delivery does not count as a legal ball.
    bool isExtraDelivery = extras.isWide || extras.isNoBall;
    _updateCurrentOverRuns(ballOutcome, isExtraDelivery);

    //* Update the striker’s score only if this delivery is credited to the batsman.
    //* (i.e. not for wides, byes, leg byes, or a no-ball that resulted in byes/leg byes)
    _updateStrikerScore(
      runs: runs,
      isWicket: isWicket,
      extras: extras,
      outBatsmanId: outBatsman,
    );

    //* Update the bowler’s score.
    _updateBowlerScore(
      runs: runs,
      isWicket: isWicket,
      extras: extras,
    );
  }

  //* Helper method to update the innings state.
  void _updateInnings({
    List<BattingScore>? battingStats,
    List<BowlingScore>? bowlingStats,
    int? wickets,
  }) {
    if (currentInnings == null) return;

    final updatedInnings = currentInnings!.copyWith(
      battingStats: battingStats,
      bowlingStats: bowlingStats,
      wickets: wickets,
    );

    _updateCurrentInnings(updatedInnings);
  }

  //* Helper to refresh the current innings in the match state.
  void _updateCurrentInnings(Inning updatedInnings) {
    if (state == null) return;

    if (state!.inning2 != null) {
      state = state!.copyWith(inning2: updatedInnings);
    } else {
      state = state!.copyWith(inning1: updatedInnings);
    }
  }

  //* Updates the current over's ball outcomes.
  //*
  //* If the delivery is extra (wide/no-ball) the ball is not counted as a legal ball,
  //* so an extra slot (null) is appended.
  void _updateCurrentOverRuns(BallOutcome updatedOverRuns, bool isExtra) {
    if (state == null) return;
    var currentOverRuns = List<BallOutcome?>.from(state!.currentOverRuns);

    for (int i = 0; i < currentOverRuns.length; i++) {
      if (currentOverRuns[i] == null) {
        currentOverRuns[i] = updatedOverRuns;
        break;
      }
    }

    if (isExtra) {
      currentOverRuns = [...currentOverRuns, null];
    }

    state = state!.copyWith(currentOverRuns: currentOverRuns);
  }

  //* Returns the number of remaining legal deliveries in the current over.
  int get remainingBalls {
    if (state == null) return 0;
    if (currentInnings == null) return 6;
    final rBalls = 6 - currentInnings!.remainingBalls;
    return rBalls;
  }

  //* Checks if an over is complete (6 legal deliveries).
  bool _isCompletedOver(int balls) => balls % 6 == 0;

  //* Checks if the last over was a maiden for the specified bowler.
  //*
  //* (This placeholder should be replaced with logic that inspects the last 6 legal deliveries.)
  bool _isLastOverMaiden(String bowlerId) {
    // TODO: Implement maiden over logic based on last 6 legal deliveries.
    return false; // Placeholder
  }

  // Match completion
  void endMatch({
    required String winningTeamId,
    required WinningMethod method,
    required int margin,
  }) {
    if (state == null) return;

    state!.setMatchResult(
      winningTeamId: winningTeamId,
      method: method,
      margin: margin,
    );
  }
}

final matchStateProvider = StateNotifierProvider<MatchStateNotifier, Match?>(
  (ref) {
    return MatchStateNotifier(null);
  },
);
