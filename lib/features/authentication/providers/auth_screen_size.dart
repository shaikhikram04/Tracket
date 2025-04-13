import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/utils/constants/sizes.dart';

enum AuthScreenType {
  userLogin,
  userSignup,
  playerLogin,
  playerSignup,
}

//* Manages the size state of authentication screens
class AuthScreenSizeNotifier extends StateNotifier<double> {
  //* Creates an instance with initial size set to user login form height
  AuthScreenSizeNotifier() : super(TSizes.playerLoginFormHeight);

  void changeScreen(AuthScreenType screen) {
    final heightMap = {
      AuthScreenType.userLogin: TSizes.userLoginFormHeight,
      AuthScreenType.userSignup: TSizes.userSignupFormHeight,
      AuthScreenType.playerLogin: TSizes.playerLoginFormHeight,
      AuthScreenType.playerSignup: TSizes.playerSignupFormHeight,
    };
    state = heightMap[screen]!;
  }

  void hasError() {
    final errorHeightMap = {
      TSizes.userLoginFormHeight: TSizes.userLoginErrorHeight,
      TSizes.userSignupFormHeight: TSizes.userSignupErrorHeight,
      TSizes.playerSignupFormHeight: TSizes.playerSignupErrorHeight,
    };
    state = errorHeightMap[state] ?? state;
  }

  void changeSizeByIndex(int index) {
    if (index == 0) {
      state = TSizes.playerLoginFormHeight;
    } else {
      state = TSizes.userLoginFormHeight;
    }
  }

  void incrementSize(double size) {
    state += size;
  }

  void resetSize() {
    state = TSizes.playerLoginFormHeight;
  }
}

final authScreenSizeProvider =
    StateNotifierProvider<AuthScreenSizeNotifier, double>(
  (ref) => AuthScreenSizeNotifier(),
);
