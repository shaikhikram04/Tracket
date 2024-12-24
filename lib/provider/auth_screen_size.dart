import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/utils/size.dart';

enum AuthScreenType {
  userLogin,
  userSignup,
  playerLogin,
  playerSignup,
}

class AuthScreenSizeNotifier extends StateNotifier<double> {
  AuthScreenSizeNotifier() : super(userLoginFormHeight);

  void changeScreen(AuthScreenType screen) {
    if (screen == AuthScreenType.userLogin) {
      state = userLoginFormHeight;
    } else if (screen == AuthScreenType.userSignup) {
      state = userSignupFormHeight;
    } else if (screen == AuthScreenType.playerLogin) {
      state = playerLoginFormHeight;
    } else if (screen == AuthScreenType.playerSignup) {
      state = playerSignupFormHeight;
    }
  }

  void hasError() {
    if (state == userLoginFormHeight) {
      state = userLoginErrorHeight;
    } else if (state == userSignupFormHeight) {
      state = userSignupErrorHeight;
    } else if (state == playerLoginFormHeight) {
      state = playerLoginErrorHeight;
    } else if (state == playerSignupFormHeight) {
      state = playerSignupErrorHeight;
    }
  }

  void incrementSize(double size) {
    state += size;
  }
}

final authScreenSizeProvider =
    StateNotifierProvider<AuthScreenSizeNotifier, double>(
  (ref) => AuthScreenSizeNotifier(),
);
