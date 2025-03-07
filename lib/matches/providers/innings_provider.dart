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
    if (currbatsman.length <= 2) {
      return currbatsman;
    } else {
      return null;
    }
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

  //* Updates the striker (and optionally the non-striker) data.
  void updateStrikers({
    required int runs,
  }) {
    if (_currentInningIndex == null || runs % 2 == 0) return;

    if (_currentInningIndex == 0) {
      state = [
        state.first!.copyWith(
          strikerPosition: state.first!.nonStrikerPosition,
          nonStrikerPosition: state.first!.strikerPosition,
        ),
        state.last,
      ];
    } else {
      state = [
        state.first,
        state.last!.copyWith(
          strikerPosition: state.last!.nonStrikerPosition,
          nonStrikerPosition: state.last!.strikerPosition,
        ),
      ];
    }
  }

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

  //* Updates the striker's score.
  //* This method is called only when the batsman should be credited
  //* (i.e. not for wides or byes/leg byes or a no-ball with byes/leg byes).
  void _updateStrikerScore({
    required int runs,
    required ExtrasState extras,
    bool isSix = false,
    bool isFour = false,
    required bool isWicket,
    String? outBatsmanId,
  }) {
    if (_currentInningIndex == null) return;

    final inning = currentInnings!;

    final strikerPosition = inning.strikerPosition;
    final nonStrikerPosition = inning.nonStrikerPosition;

    //* Wicket handling:
    if (isWicket) {
      //* If the striker is out (or for run-outs affecting the non-striker)
      if (outBatsmanId == null ||
          outBatsmanId == inning.battingStats[strikerPosition].uuid) {
        final updatedStriker =
            inning.battingStats[strikerPosition].wicket(runs, !extras.isWide);

        inning.battingStats.map((player) {
          if (player.uuid == updatedStriker.uuid) {
            return updatedStriker;
          }
          return player;
        }).toList();

        if (_currentInningIndex == 0) {
          state = [
            state.first!.copyWith(
              battingStats: inning.battingStats,
              strikerPosition: -1,
            ),
            state.last,
          ];
        } else {
          state = [
            state.first,
            state.last!.copyWith(
              battingStats: inning.battingStats,
              strikerPosition: -1,
            ),
          ];
        }
      } else {
        //* Non-striker gets dismissed (commonly in a run-out).
        final updatedNonStriker =
            inning.battingStats[nonStrikerPosition].wicket(0, false);

        final updatedStriker = inning.battingStats[strikerPosition]
            .addRuns(runs, isFour: isFour, isSix: isSix);

        if (_currentInningIndex == 0) {
          state = [
            state.first!.copyWith(
              battingStats: inning.battingStats.map((player) {
                if (player.uuid == updatedStriker.uuid) {
                  return updatedStriker;
                }
                if (player.uuid == updatedNonStriker.uuid) {
                  return updatedNonStriker;
                }
                return player;
              }).toList(),
              nonStrikerPosition: -1,
            ),
            state.last,
          ];
        } else {
          state = [
            state.first,
            state.last!.copyWith(
              battingStats: inning.battingStats.map((player) {
                if (player.uuid == updatedStriker.uuid) {
                  return updatedStriker;
                }
                if (player.uuid == updatedNonStriker.uuid) {
                  return updatedNonStriker;
                }
                return player;
              }).toList(),
              nonStrikerPosition: -1,
            ),
          ];
        }
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
      final updatedStriker = inning.battingStats[strikerPosition]
          .addRuns(runs, isFour: isFour, isSix: isSix);

      if (_currentInningIndex == 0) {
        state = [
          state.first!.copyWith(
            battingStats: inning.battingStats.map((player) {
              if (player.uuid == updatedStriker.uuid) {
                return updatedStriker;
              }
              return player;
            }).toList(),
          ),
          state.last,
        ];
      } else {
        state = [
          state.first,
          state.last!.copyWith(
            battingStats: inning.battingStats.map((player) {
              if (player.uuid == updatedStriker.uuid) {
                return updatedStriker;
              }
              return player;
            }).toList(),
          ),
        ];
      }
    }

    updateStrikers(runs: runs);
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
    if (_currentInningIndex == null) return;
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

    final inning = currentInnings!;
    final currentBowlerId = inning.currentBowlerId;

    final updatedBowlingStats = inning.bowlingStats
        .firstWhere((bowler) => bowler.uuid == currentBowlerId)
        .addBall(
          runs: runsForBowler,
          isWide: extras.isWide,
          isNoBall: extras.isNoBall,
          isWicket: isWicket,
        );

    if (_currentInningIndex == 0) {
      state = [
        state.first!.copyWith(
          bowlingStats: inning.bowlingStats.map((player) {
            if (player.uuid == updatedBowlingStats.uuid) {
              return updatedBowlingStats;
            }
            return player;
          }).toList(),
        ),
        state.last,
      ];
    } else {
      state = [
        state.first,
        state.last!.copyWith(
          bowlingStats: inning.bowlingStats.map((player) {
            if (player.uuid == updatedBowlingStats.uuid) {
              return updatedBowlingStats;
            }
            return player;
          }).toList(),
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

    //! Updating currentover Balls
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

    //* For an extra (wide or no-ball), the delivery does not count as a legal ball.
    bool isExtraDelivery = extras.isWide || extras.isNoBall;

    final ballOutcome = BallOutcome(
      type: ballType,
      runs: runs,
      isWicket: isWicket,
      reasonOfOut: reasonOfOut,
      ballNumber: currentInnings!.balls % 6,
      ballId: uuid.v4(),
      timestamp: Timestamp.now(),
    );

    ref.read(currentOverRunsProvider.notifier).addBalls(ballOutcome);



    // //* Update the striker’s score only if this delivery is credited to the batsman.
    // //* (i.e. not for wides, byes, leg byes, or a no-ball that resulted in byes/leg byes)
    // _updateStrikerScore(
    //   runs: runs,
    //   isWicket: isWicket,
    //   extras: extras,
    //   outBatsmanId: outBatsman,
    //   isFour: isFour,
    //   isSix: isSix,
    // );

    // //* Update the bowler’s score.
    // _updateBowlerScore(
    //   runs: runs,
    //   isWicket: isWicket,
    //   extras: extras,
    // );
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
