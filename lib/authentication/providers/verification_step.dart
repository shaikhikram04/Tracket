import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerificationStepNotifier extends StateNotifier<int> {
  VerificationStepNotifier() : super(0);

  void updateStep(int step) {
    state = step;
  }
}

final verificationStepProvider =
    StateNotifierProvider<VerificationStepNotifier, int>(
  (ref) => VerificationStepNotifier(),
);
