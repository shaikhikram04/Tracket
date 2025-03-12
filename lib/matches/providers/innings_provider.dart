import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/matches/models/ball_outcome.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/providers/current_over_runs_provider.dart';
import 'package:tracket/matches/providers/extras_provider.dart';
import 'package:tracket/matches/providers/match_provider.dart';
import 'package:tracket/matches/services/matches_services.dart';

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
    return currentInnings!.bowlingStats
        .firstWhere((bowler) => bowler.uuid == currentInnings!.currentBowlerId);
  }

  void setInnings(List<Inning?> innings) {
    state = innings;
  }

  //* Starts the first innings.
  void startFirstInnings(Inning inning) {
    final match = ref.read(matchStateProvider);
    if (match == null) return;

    // final inning1 = match.initializeFirstInnings(
    //   strikerPosition: strikerPosition,
    //   nonStrikerPosition: nonStrikerPosition,
    //   bowlerId: bowlerId,
    // );

    state = [inning, null];
  }

  // //* Starts the second innings.
  // void startSecondInnings({
  //   required int bowlerId,
  //   required int strikerPosition,
  //   required int nonStrikerPosition,
  // }) {
  //   final match = ref.read(matchStateProvider);
  //   if (match == null) return;

  //   final inning2 = match.initializeFirstInnings(
  //     strikerPosition: strikerPosition,
  //     nonStrikerPosition: nonStrikerPosition,
  //     bowlerId: bowlerId,
  //   );

  //   state = [state.first, inning2];
  // }

  void setNewBatsmenOnOut(MatchPlayerInfo newBatsman) {
    if (_currentInningIndex == null) return;

    final battingPosition = currentInnings!.battingStats.length + 1;
    final newBatsmanStat = BattingScore(
      uuid: newBatsman.playerId,
      playerName: newBatsman.playerName,
      battingPosition: battingPosition,
    );

    if (_currentInningIndex == 0) {
      state = [
        state.first!.copyWith(
          strikerPosition: state.first!.strikerPosition != -1
              ? battingPosition
              : state.first!.strikerPosition,
          nonStrikerPosition: state.first!.nonStrikerPosition != -1
              ? battingPosition
              : state.first!.nonStrikerPosition,
          battingStats: [...state.first!.battingStats, newBatsmanStat],
        ),
        state.last,
      ];
    } else {
      state = [
        state.first,
        state.last!.copyWith(
          strikerPosition: state.last!.strikerPosition != -1
              ? battingPosition
              : state.last!.strikerPosition,
          nonStrikerPosition: state.last!.nonStrikerPosition != -1
              ? battingPosition
              : state.last!.nonStrikerPosition,
          battingStats: [...state.last!.battingStats, newBatsmanStat],
        ),
      ];
    }
  }

  //* Sets the current bowler on start of innings.
  void setCurrentBowler(String newBowlerId) {
    if (_currentInningIndex == null) return;

    if (_currentInningIndex == 0) {
      state = [
        state.first!.copyWith(currentBowlerId: newBowlerId),
        state.last,
      ];
    } else {
      state = [
        state.first,
        state.last!.copyWith(currentBowlerId: newBowlerId),
      ];
    }
  }

  //* Changes the bowler on over change.
  void changeBowler(String newBowlerId) {
    if (_currentInningIndex == null) return;

    if (_currentInningIndex == 0) {
      state = [
        state.first!.copyWith(
          currentBowlerId: newBowlerId,
          strikerPosition: state.first!.nonStrikerPosition,
          nonStrikerPosition: state.first!.strikerPosition,
        ),
        state.last,
      ];
    } else {
      state = [
        state.first,
        state.last!.copyWith(
          currentBowlerId: newBowlerId,
          strikerPosition: state.last!.nonStrikerPosition,
          nonStrikerPosition: state.last!.strikerPosition,
        ),
      ];
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

    final ballOutcome = BallOutcome(
      type: ballType,
      runs: runs,
      isWicket: isWicket,
      reasonOfOut: reasonOfOut,
      ballNumber: extras.isWide || extras.isNoBall
          ? currentInnings!.balls % 7
          : currentInnings!.balls % 7 + 1,
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
      isOverCompleted: isOverCompleted,
    );

    _updateCurrentInnings(updatedInnings);

    final matchState = ref.read(matchStateProvider)!;

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
      teamScore: matchState.team2Score ?? matchState.team1Score!,
      ballOutCome: ballOutcome,
      isOverCompleted: isOverCompleted,
      isMaiden: ref.read(currentOverRunsProvider.notifier).isLastOverMaiden(),
      isWicket: isWicket,
      outBatsmanPosition: outBatsmanPosition,
      reasonOfOut: reasonOfOut,
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
