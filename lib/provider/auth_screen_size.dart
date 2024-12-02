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
}

final authScreenSizeProvider =
    StateNotifierProvider<AuthScreenSizeNotifier, double>(
  (ref) => AuthScreenSizeNotifier(),
);
