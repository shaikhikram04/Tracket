import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerificationStepNotifier extends StateNotifier<int> {
  static const int minStep = 0;
  static const int maxStep = 3; // adjust based on your total steps

  VerificationStepNotifier() : super(minStep);

  void resetStep() {
    state = minStep;
  }

  void updateStep(int step) {
    if (step >= minStep && step <= maxStep) {
      state = step;
    }
  }
}

final verificationStepProvider =
    StateNotifierProvider<VerificationStepNotifier, int>(
  (ref) => VerificationStepNotifier(),
);
