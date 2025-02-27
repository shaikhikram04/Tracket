import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/matches/models/ball_outcome.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/providers/additional_match_provider.dart';
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

  //* Starts the first innings.
  void startFirstInnings({
    required int strikerIndex,
    required int nonStrikerIndex,
    required int bowlerIndex,
  }) {
    final match = ref.read(matchStateProvider);
    if (match == null) return;

    final inning1 = match.initializeFirstInnings(
      strikerIndex: strikerIndex,
      nonStrikerIndex: nonStrikerIndex,
      bowlerIndex: bowlerIndex,
    );

    state = [inning1, null];

    ref.read(matchStateProvider.notifier).updateMatchStatus(MatchStatus.live);
  }

  //* Starts the second innings.
  void startSecondInnings({
    required int bowlerIndex,
    required int strikerIndex,
    required int nonStrikerIndex,
  }) {
    final match = ref.read(matchStateProvider);
    if (match == null) return;

    final inning2 = match.initializeFirstInnings(
      strikerIndex: strikerIndex,
      nonStrikerIndex: nonStrikerIndex,
      bowlerIndex: bowlerIndex,
    );

    state = [state.first, inning2];
  }

  //* Updates the striker (and optionally the non-striker) data.
  void updateStrikers({
    required int runs,
  }) {
    if (_currentInningIndex == null || runs % 2 == 0) return;

    if (_currentInningIndex == 0) {
      state = [
        state.first!.copyWith(
          strikerIndex: state.first!.nonStrikerIndex,
          nonStrikerIndex: state.first!.strikerIndex,
        ),
        state.last,
      ];
    } else {
      state = [
        state.first,
        state.last!.copyWith(
          strikerIndex: state.last!.nonStrikerIndex,
          nonStrikerIndex: state.last!.strikerIndex,
        ),
      ];
    }
  }

  void setNewBatsmenOnOut(int newBatsmanIndex) {
    if (_currentInningIndex == null) return;
    if (_currentInningIndex == 0) {
      state = [
        state.first!.copyWith(
          strikerIndex: state.first!.strikerIndex != -1
              ? newBatsmanIndex
              : state.first!.strikerIndex,
          nonStrikerIndex: state.first!.nonStrikerIndex != -1
              ? newBatsmanIndex
              : state.first!.nonStrikerIndex,
        ),
        state.last,
      ];
    } else {
      state = [
        state.first,
        state.last!.copyWith(
          strikerIndex: state.last!.strikerIndex != -1
              ? newBatsmanIndex
              : state.last!.strikerIndex,
          nonStrikerIndex: state.last!.nonStrikerIndex != -1
              ? newBatsmanIndex
              : state.last!.nonStrikerIndex,
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

    final inning = state[_currentInningIndex!]!;

    final strikerIndex = inning.strikerIndex;
    final nonStrikerIndex = inning.nonStrikerIndex;

    //* Wicket handling:
    if (isWicket) {
      //* If the striker is out (or for run-outs affecting the non-striker)
      if (outBatsmanId == null ||
          outBatsmanId == inning.battingStats[strikerIndex].uuid) {
        final updatedStriker =
            inning.battingStats[strikerIndex].wicket(runs, !extras.isWide);

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
              strikerIndex: -1,
            ),
            state.last,
          ];
        } else {
          state = [
            state.first,
            state.last!.copyWith(
              battingStats: inning.battingStats,
              strikerIndex: -1,
            ),
          ];
        }
      } else {
        //* Non-striker gets dismissed (commonly in a run-out).
        final updatedNonStriker =
            inning.battingStats[nonStrikerIndex].wicket(0, false);

        final updatedStriker = inning.battingStats[strikerIndex]
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
              nonStrikerIndex: -1,
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
              nonStrikerIndex: -1,
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
      final updatedStriker = inning.battingStats[strikerIndex]
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
    final currentBowlerIndex = inning.currentBowlerIndex;

    final updatedBowlingStats = inning.bowlingStats[currentBowlerIndex].addBall(
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
  void setCurrentBowler(int newBowlerIndex) {
    if (_currentInningIndex == null) return;

    if (_currentInningIndex == 0) {
      state = [
        state.first!.copyWith(currentBowlerIndex: newBowlerIndex),
        state.last,
      ];
    } else {
      state = [
        state.first,
        state.last!.copyWith(currentBowlerIndex: newBowlerIndex),
      ];
    }
  }

  //* Changes the bowler on over change.
  void changeBowler(int newBowlerIndex) {
    if (_currentInningIndex == null) return;

    if (_currentInningIndex == 0) {
      state = [
        state.first!.copyWith(
          currentBowlerIndex: newBowlerIndex,
          strikerIndex: state.first!.nonStrikerIndex,
          nonStrikerIndex: state.first!.strikerIndex,
        ),
        state.last,
      ];
    } else {
      state = [
        state.first,
        state.last!.copyWith(
          currentBowlerIndex: newBowlerIndex,
          strikerIndex: state.last!.nonStrikerIndex,
          nonStrikerIndex: state.last!.strikerIndex,
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
      ballNumber: currentInnings!.balls +
          (ballType == BallType.valid ||
                  ballType == BallType.legBye ||
                  ballType == BallType.bye
              ? 1
              : 0),
      ballId: uuid.v4(),
      timestamp: Timestamp.now(),
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
      isFour: isFour,
      isSix: isSix,
    );

    //* Update the bowler’s score.
    _updateBowlerScore(
      runs: runs,
      isWicket: isWicket,
      extras: extras,
    );

    if (_isCompletedOver(currentInnings!.balls)) {
      ref.read(additionalMatchProvider.notifier).setIsOverCompleted(true);
    }
  }

  //* Updates the current over's ball outcomes.
  //*
  //* If the delivery is extra (wide/no-ball) the ball is not counted as a legal ball,
  //* so an extra slot (null) is appended.
  void _updateCurrentOverRuns(BallOutcome updatedOverRuns, bool isExtra) {
    if (currentInnings == null) return;
    // var currentOverRuns = List<BallOutcome?>.from(state!.currentOverRuns);

    // for (int i = 0; i < currentOverRuns.length; i++) {
    //   if (currentOverRuns[i] == null) {
    //     currentOverRuns[i] = updatedOverRuns;
    //     break;
    //   }
    // }

    // if (isExtra) {
    //   currentOverRuns = [...currentOverRuns, null];
    // }

    // TODO : Create a seperate provider for BallOutcome
    // state = state!.copyWith(currentOverRuns: currentOverRuns);
  }

  //* Returns the number of remaining legal deliveries in the current over.
  int get remainingBalls {
    if (state == null) return 0;
    if (currentInnings == null) return 6;
    final rBalls = 6 - currentInnings!.remainingBalls;
    return rBalls;
  }

  //* Checks if an over is complete (6 legal deliveries).
  bool _isCompletedOver(int balls) {
    if (balls == 0) return false;
    return balls % 6 == 0;
  }

  //* Checks if the last over was a maiden for the specified bowler.
  //*
  //* (This placeholder should be replaced with logic that inspects the last 6 legal deliveries.)
  bool _isLastOverMaiden(String bowlerId) {
    // TODO: Implement maiden over logic based on last 6 legal deliveries.
    return false; // Placeholder
  }
}

final inningsStateProvider =
    StateNotifierProvider<InningsStateNotifier, List<Inning?>>(
  (ref) => InningsStateNotifier(ref),
);
