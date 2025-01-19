import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/utils/size.dart';

enum AuthScreenType {
  userLogin,
  userSignup,
  playerLogin,
  playerSignup,
}

//* Manages the size state of authentication screens
class AuthScreenSizeNotifier extends StateNotifier<double> {
  //* Creates an instance with initial size set to user login form height
  AuthScreenSizeNotifier() : super(playerLoginFormHeight);

  void changeScreen(AuthScreenType screen) {
    final heightMap = {
      AuthScreenType.userLogin: userLoginFormHeight,
      AuthScreenType.userSignup: userSignupFormHeight,
      AuthScreenType.playerLogin: playerLoginFormHeight,
      AuthScreenType.playerSignup: playerSignupFormHeight,
    };
    state = heightMap[screen]!;
  }

  void hasError() {
    final errorHeightMap = {
      userLoginFormHeight: userLoginErrorHeight,
      userSignupFormHeight: userSignupErrorHeight,
      playerSignupFormHeight: playerSignupErrorHeight,
    };
    state = errorHeightMap[state] ?? state;
  }

  void changeSizeByIndex(int index) {
    if (index == 0) {
      state = playerLoginFormHeight;
    } else {
      state = userLoginFormHeight;
    }
  }

  void incrementSize(double size) {
    state += size;
  }

  void resetSize() {
    state = playerLoginFormHeight;
  }
}

final authScreenSizeProvider =
    StateNotifierProvider<AuthScreenSizeNotifier, double>(
  (ref) => AuthScreenSizeNotifier(),
);
