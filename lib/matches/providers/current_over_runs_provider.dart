import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/matches/models/ball_outcome.dart';

class CurrentOverRunsNotifier extends StateNotifier<List<BallOutcome>> {
  CurrentOverRunsNotifier() : super([]);

  //* Updates the current over's ball outcomes.
  //*
  //* If the delivery is extra (wide/no-ball) the ball is not counted as a legal ball,
  //* so an extra slot (null) is appended.
  void addBalls(BallOutcome updatedOverRuns, bool isExtra) {
    state = [...state, updatedOverRuns];
  }

  int get remainingBalls {
    if (state.isEmpty) {
      return 6;
    }
    return 6 - state.last.remainingBalls;
  }

  //* Checks if an over is complete (6 legal deliveries).
  bool isOverCompleted() {
    if (state.isEmpty) return false;

    return state.last.ballNumber == 6;
  }

  int get totalRuns {
    return state.fold<int>(
      0,
      (total, ballOutcome) => total + ballOutcome.runs,
    );
  }

   bool isLastOverMaiden(String bowlerId) {
    if (state.isEmpty || state.last.ballNumber < 6) return false;

    return totalRuns == 0;
  }

  void clear() {
    state = [];
  }
}

final currentOverRunsProvider =
    StateNotifierProvider<CurrentOverRunsNotifier, List<BallOutcome>>((ref) {
  return CurrentOverRunsNotifier();
});
