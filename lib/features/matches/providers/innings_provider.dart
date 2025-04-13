import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/matches/models/ball_outcome.dart';
import 'package:tracket/features/matches/models/batting_score.dart';
import 'package:tracket/features/matches/models/bowling_score.dart';
import 'package:tracket/features/matches/models/inning.dart';
import 'package:tracket/features/matches/models/match.dart';
import 'package:tracket/features/matches/models/match_player_info.dart';
import 'package:tracket/features/matches/providers/additional_match_provider.dart';
import 'package:tracket/features/matches/providers/current_over_runs_provider.dart';
import 'package:tracket/features/matches/providers/extras_provider.dart';
import 'package:tracket/features/matches/providers/match_provider.dart';
import 'package:tracket/features/matches/services/matches_services.dart';

class InningsStateNotifier extends StateNotifier<List<Inning?>> {
  InningsStateNotifier(this.ref) : super([null, null]);

  final Ref ref;

  int? get _currentInningIndex {
    if (state.isEmpty) {
      return null;
    }
    if (state.last != null) {
      return 1;
    }
    if (state.first != null) {
      return 0;
    }
    return null;
  }

  //* Returns the current innings (if second innings has started, use that).
  Inning? get currentInnings {
    if (state.first == null) return null;
    return state.last ?? state.first;
  }

  List<BattingScore>? get currentBatsmen {
    if (_currentInningIndex == null) return null;

    final strikerPosition = currentInnings!.strikerPosition;
    final nonStrikerPosition = currentInnings!.nonStrikerPosition;
    final positions = [strikerPosition, nonStrikerPosition];

    final currbatsman = currentInnings!.battingStats
        .where(
          (batsman) => positions.contains(batsman.battingPosition),
        )
        .toList();

    if (currbatsman.length > 2) {
      return null;
    }

    return currbatsman;
  }

  BowlingScore? get currentBowler {
    if (_currentInningIndex == null) return null;
    final currentBowlerIndex = currentInnings!.bowlingStats.indexWhere(
      (bowler) => bowler.uuid == currentInnings!.currentBowlerId,
    );

    if (currentBowlerIndex == -1) {
      final currBowlerInfo =
          ref.read(matchStateProvider)!.getBowlingTeamPlayers().firstWhere(
                (bowler) => bowler.playerId == currentInnings!.currentBowlerId,
              );

      final bowlingStats = BowlingScore(
        uuid: currBowlerInfo.playerId,
        playerName: currBowlerInfo.playerName,
      );

      return bowlingStats;
    } else {
      return currentInnings!.bowlingStats[currentBowlerIndex];
    }
  }

  void setInnings(List<Inning?> innings) {
    state = innings;
  }

  int? get target {
    if (state.last == null) return null;

    return state.first!.runs + 1;
  }

  Future<void> setNewBatsmenOnOut(MatchPlayerInfo newBatsman) async {
    if (currentInnings == null) return;

    final battingPosition = currentInnings!.battingStats.length + 1;
    final newBatsmanStat = BattingScore(
      uuid: newBatsman.playerId,
      playerName: newBatsman.playerName,
      battingPosition: battingPosition,
    );

    final outBatsmanPosition = currentBatsmen!.firstWhere((batsman) {
      return batsman.isOut;
    }).battingPosition;

    if (_currentInningIndex == 0) {
      state = [
        state.first!.copyWith(
          strikerPosition: outBatsmanPosition == currentInnings!.strikerPosition
              ? battingPosition
              : currentInnings!.strikerPosition,
          nonStrikerPosition:
              outBatsmanPosition == currentInnings!.nonStrikerPosition
                  ? battingPosition
                  : currentInnings!.nonStrikerPosition,
          battingStats: [...currentInnings!.battingStats, newBatsmanStat],
        ),
        state.last,
      ];
    } else {
      state = [
        state.first,
        state.last!.copyWith(
          strikerPosition: outBatsmanPosition == currentInnings!.strikerPosition
              ? battingPosition
              : currentInnings!.strikerPosition,
          nonStrikerPosition:
              outBatsmanPosition == currentInnings!.nonStrikerPosition
                  ? battingPosition
                  : currentInnings!.nonStrikerPosition,
          battingStats: [...currentInnings!.battingStats, newBatsmanStat],
        ),
      ];
    }

    await MatchesServices.setNewBatsmanOnWicket(
      matchId: ref.read(matchStateProvider)!.id,
      newBatsmanStat: newBatsmanStat,
      strikerPosition: currentInnings!.strikerPosition,
      nonStrikerPosition: currentInnings!.nonStrikerPosition,
      currentInningNo: _currentInningIndex! + 1,
    );
  }

  //* Changes the bowler on over change.
  Future<void> changeBowler(String newBowlerId) async {
    if (_currentInningIndex == null) return;

    final isExistingBowler = currentInnings!.bowlingStats.any(
      (bowler) => bowler.uuid == newBowlerId,
    );

    BowlingScore? newBowlerStat;
    if (isExistingBowler == false) {
      final matchState = ref.read(matchStateProvider)!;
      final playersList = matchState.getBowlingTeamPlayers();
      final playerInfo = playersList.firstWhere(
        (player) => player.playerId == newBowlerId,
      );
      final playerName = playerInfo.playerName;
      newBowlerStat = BowlingScore(
        uuid: newBowlerId,
        playerName: playerName,
      );
    }

    if (_currentInningIndex == 0) {
      state = [
        state.first!.copyWith(
          currentBowlerId: newBowlerId,
          bowlingStats: isExistingBowler
              ? null
              : [...currentInnings!.bowlingStats, newBowlerStat!],
        ),
        state.last,
      ];
    } else {
      state = [
        state.first,
        state.last!.copyWith(
          currentBowlerId: newBowlerId,
          bowlingStats: isExistingBowler
              ? null
              : [...currentInnings!.bowlingStats, newBowlerStat!],
        ),
      ];
    }

    await MatchesServices.setNewBowlerOnOverCompleted(
      matchId: ref.read(matchStateProvider)!.id,
      currentInningNo: _currentInningIndex! + 1,
      newBowlerStat: newBowlerStat,
      currentBowlerId: newBowlerId,
    );
  }

  String get currentWicketkeeperName {
    final wkId = currentInnings!.bowlingTeam.wicketkeeperId;
    try {
      final matchState = ref.read(matchStateProvider)!;
      final playersList = matchState.getBowlingTeamPlayers();

      return playersList
          .firstWhere((player) => player.playerId == wkId)
          .playerName;
    } catch (e) {
      return 'Unknown';
    }
  }

  //* Adds a delivery outcome.
  //*
  //* This method applies the full cricket scoring rules:
  //* - **Team Score:** Includes penalty extras (e.g. 1 run for a no-ball or wide)
  //*   plus any additional runs scored.
  //* - **Batsman:** Only credited if the delivery is not “extra” (except a no-ball
  //*   where the batsman hits the ball).
  //* - **Bowler:** Charged based on the type of extra (byes/leg byes aren't counted).
  //* - **Wicket:** Dismissals on a no-ball are disallowed (except run outs).
  Future<void> addDelivery({
    required int runs,
    required bool isFour,
    required bool isSix,
    required ExtrasState extras,
    bool isWicket = false,
    int? outBatsmanPosition,
    ReasonOfOut? reasonOfOut,
    String? dismissalInfo,
  }) async {
    if (currentInnings == null) return;

    //* In a no-ball delivery (except run outs), dismissals are not allowed.
    if (extras.isNoBall && isWicket && (reasonOfOut != ReasonOfOut.runOut)) {
      isWicket = false;
    }

    final teamExtras = currentInnings!.extras;
    final strikerPosition = currentInnings!.strikerPosition;
    final nonStrikerPosition = currentInnings!.nonStrikerPosition;
    final currentBowlerId = currentInnings!.currentBowlerId;

    //! Updating currentover Balls
    //* Determine the type of delivery.
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

    final currentInningBallCount = extras.isWide || extras.isNoBall
        ? currentInnings!.balls
        : currentInnings!.balls + 1;

    final ballOutcome = BallOutcome(
      type: ballType,
      runs: runs,
      isWicket: isWicket,
      reasonOfOut: reasonOfOut,
      ballNumber:
          currentInningBallCount % 6 == 0 ? 6 : currentInningBallCount % 6,
      ballId: uuid.v4(),
      timestamp: Timestamp.now(),
      isBoundary: isFour || isSix,
    );

    ref.read(currentOverRunsProvider.notifier).addBalls(ballOutcome);

    final bool isOverCompleted = ballOutcome.remainingBalls == 0;

    //* Calculate the total team runs for this delivery.
    //* - For a wide: 1 (penalty) + any additional runs (from running).
    //* - For a no-ball: 1 (penalty) + batsman`s runs (if valid shot) or, if accompanied
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

    final matchState = ref.read(matchStateProvider)!;
    final noOfPlayers = matchState.noOfPlayer;
    final matchOvers = matchState.over;

    final isAllOut =
        currentInnings!.wickets + (isWicket ? 1 : 0) == (noOfPlayers - 1);

    final isInningCompleted =
        (target != null && currentInnings!.runs + totalTeamRuns >= target!) ||
            currentInningBallCount == matchOvers * 6 ||
            isAllOut;

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
      outBatsmanPosition: outBatsmanPosition,
      isInningCompleted: isInningCompleted,
      isOverCompleted: isOverCompleted,
      dismissalInfo: dismissalInfo,
      reasonOfOut: reasonOfOut,
    );

    _updateCurrentInnings(updatedInnings);

    final isMatchCompleted = isInningCompleted && _currentInningIndex == 1;

    String? winningTeamId = null;
    WinningMethod? winningMethod = null;
    int? winningMargin = null;
    if (isMatchCompleted) {
      ref.read(additionalMatchProvider.notifier).setIsMatchCompleted(true);
      final iscurrentBattingTeamWin = currentInnings!.runs > state.first!.runs;
      winningTeamId = iscurrentBattingTeamWin
          ? currentInnings!.battingTeam.teamId
          : state.first!.battingTeam.teamId;

      winningMethod = iscurrentBattingTeamWin
          ? WinningMethod.byWickets
          : WinningMethod.byRuns;

      winningMargin = iscurrentBattingTeamWin
          ? noOfPlayers - currentInnings!.wickets - 1
          : state.first!.runs - currentInnings!.runs;

      ref.read(matchStateProvider.notifier).endMatch(
            winningTeamId: winningTeamId,
            method: winningMethod,
            margin: winningMargin,
          );
    } else if (isInningCompleted) {
      ref.read(additionalMatchProvider.notifier).setIsInningsCompleted(true);
    }

    final teamScore = _currentInningIndex == 0
        ? matchState.team1Score!
        : matchState.team2Score!;
    final updatedTeamScore = teamScore.addDelevery(
        runs: runs, isAddBall: extras.shouldAddRunsToTeam, isWicket: isWicket);

    ref.read(matchStateProvider.notifier).updateTeamScore(updatedTeamScore);

    await MatchesServices.updateMatchScore(
      matchId: matchState.id,
      currentInningNo: _currentInningIndex! + 1,
      runs: runs,
      isFour: isFour,
      isSix: isSix,
      teamExtras: teamExtras,
      strikerPosition: strikerPosition,
      nonStrikerPosition: nonStrikerPosition,
      currentBowlerId: currentBowlerId,
      extras: extras,
      teamScore: updatedTeamScore,
      ballOutCome: ballOutcome,
      isOverCompleted: isOverCompleted,
      isMaiden: ref.read(currentOverRunsProvider.notifier).isLastOverMaiden(),
      isWicket: isWicket,
      outBatsmanPosition: outBatsmanPosition,
      reasonOfOut: reasonOfOut,
      fallOfWickets: isWicket ? updatedInnings.fallOfWickets.last : null,
      dismissalInfo: dismissalInfo,
      isInningCompleted: isInningCompleted,
      isMatchCompleted: isMatchCompleted,
      winningMargin: isMatchCompleted ? winningMargin : null,
      winningMethod: isMatchCompleted ? winningMethod : null,
      winningTeamId: isMatchCompleted ? winningTeamId : null,
    );
  }

  //* Helper to refresh the current innings in the match state.
  void _updateCurrentInnings(Inning updatedInnings) {
    if (currentInnings == null) return;

    if (_currentInningIndex == 0) {
      state = [updatedInnings, state.last];
    } else {
      state = [state.first, updatedInnings];
    }
  }
}

final inningsStateProvider =
    StateNotifierProvider<InningsStateNotifier, List<Inning?>>(
  (ref) => InningsStateNotifier(ref),
);
