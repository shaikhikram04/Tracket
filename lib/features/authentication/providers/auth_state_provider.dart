// Create a StateNotifier to manage the state
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/authentication/models/player_auth_state.dart';
import 'package:tracket/features/authentication/models/verification_data.dart';
import 'package:tracket/features/authentication/providers/auth_screen_size.dart';
import 'package:tracket/features/authentication/providers/verification_step.dart';
import 'package:tracket/features/authentication/services/email_verification_services.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/players/models/player_cricket_detail.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class PlayerAuthNotifier extends StateNotifier<PlayerAuthState> {
  final Ref ref;

  PlayerAuthNotifier(this.ref) : super(PlayerAuthState(formKey: GlobalKey<FormState>()));

  void reset() {
    state = PlayerAuthState(formKey: GlobalKey<FormState>());
  }

  void updateRole(String? role) {
    if (role == null) return;

    final newRole = PlayerCricketDetails.getCricketRole(role);
    final shouldBeBowler = newRole == CricketRole.bowler || newRole == CricketRole.allRounder;

    if (shouldBeBowler != state.isBowler) {
      ref.read(authScreenSizeProvider.notifier).incrementSize(shouldBeBowler ? 86 : -86);
    }

    state = state.copyWith(
      cricketRole: newRole,
      isBowler: shouldBeBowler,
    );
  }

  void updateBowlingStyle(String? style) {
    if (style == null) return;

    bool isBowler = state.isBowler;
    if (style != BowlingStyle.none.name && !isBowler) {
      ref.read(authScreenSizeProvider.notifier).incrementSize(86);
      isBowler = true;
    } else if (style == BowlingStyle.none.name && isBowler) {
      ref.read(authScreenSizeProvider.notifier).incrementSize(-86);
      isBowler = false;
    }

    state = state.copyWith(
      bowlingStyle: PlayerCricketDetails.getBowlingStyle(style),
      isBowler: isBowler,
    );
    
  }

  void updateField({
    String? arm,
    String? position,
    String? playerName,
    String? email,
    String? password,
  }) {
    state = state.copyWith(
      bowlingArm: arm != null ? PlayerCricketDetails.getPosition(arm) : state.bowlingArm,
      battingPosition: position != null ? PlayerCricketDetails.getPosition(position) : state.battingPosition,
      playerName: playerName ?? state.playerName,
      email: email ?? state.email,
      password: password ?? state.password,
    );
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordHidden: !state.isPasswordHidden);
  }

  void toggleUserAuth() {
    ref.read(authScreenSizeProvider.notifier).changeScreen(
          state.isLogin ? AuthScreenType.userSignup : AuthScreenType.userLogin,
        );

    final isLogin = state.isLogin;
    reset();
    state = state.copyWith(isLogin: !isLogin);
  }

  void togglePlayerAuth() {
    ref.read(authScreenSizeProvider.notifier).changeScreen(
          state.isLogin ? AuthScreenType.playerSignup : AuthScreenType.playerLogin,
        );

    final isLogin = state.isLogin;
    reset();
    state = state.copyWith(isLogin: !isLogin);
  }

  Future<void> login(BuildContext context, bool isPlayer) async {
    if (!_validateForm(context)) return;

    state = state.copyWith(isLoading: true);
    try {
      await FirebaseAuthMethods().login(
        email: state.email!.trim(),
        password: state.password!.trim(),
        expectedRole: isPlayer ? 'player' : 'user',
        context: context,
        ref: ref,
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signup(BuildContext context, bool isPlayer) async {
    if (!_validateForm(context)) return;
    if (isPlayer && !_validateDropdowns(context)) return;

    state = state.copyWith(isLoading: true);
    try {
      THelperFunction.showVerificationDialog(context, state.email!);

      final user = await FirebaseAuthMethods().sendVerificationEmail(
        state.email!.trim(),
        state.password!.trim(),
      );

      ref.read(verificationStepProvider.notifier).updateStep(1);

      if (!context.mounted) return;

      final verificationData = VerificationData(
        user: user!,
        username: state.playerName!.trim(),
        ref: ref,
        context: context,
        role: isPlayer ? 'player' : 'user',
        imageUrl: '',
        cricketRole: state.cricketRole,
        battingPosition: state.battingPosition,
        bowlingStyle: state.bowlingStyle,
        bowlingArm: state.bowlingArm,
      );

      await EmailVerificationService.checkEmailVerification(
        data: verificationData,
      );
    } catch (e) {
      if (!context.mounted) return;
      _handleError(context, e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  bool _validateForm(BuildContext context) {
    if (!state.formKey.currentState!.validate()) {
      ref.read(authScreenSizeProvider.notifier).hasError();
      return false;
    }
    state.formKey.currentState!.save();
    return true;
  }

  bool _validateDropdowns(BuildContext context) {
    if (!_isDropdownSelected(state.cricketRole?.name, 'Cricket Role', context)) {
      return false;
    }
    if (!_isDropdownSelected(state.battingPosition?.name, 'Batting Position', context)) {
      return false;
    }
    if (!_isDropdownSelected(state.bowlingStyle?.name, 'Bowling Style', context)) {
      return false;
    }
    if (state.isBowler && !_isDropdownSelected(state.bowlingArm?.name, 'Bowling Arm', context)) {
      return false;
    }
    return true;
  }

  void _handleError(BuildContext context, dynamic error) {
    Navigator.of(context).pop();
    ref.read(verificationStepProvider.notifier).resetStep();

    if (error is FirebaseAuthException) {
      THelperFunction.showAlertDialog(
        context,
        TTextStrings.error,
        THelperFunction.getErrorMessage(error.code),
      );
    } else {
      THelperFunction.showAlertDialog(
        context,
        TTextStrings.error,
        TTextStrings.unexpectedError,
      );
    }
  }

  bool _isDropdownSelected(String? value, String label, BuildContext context) {
    if (value == null) {
      THelperFunction.showSnackBar('Please select $label', context);
      return false;
    }
    return true;
  }
}

// Create a provider
final playerAuthProvider = StateNotifierProvider<PlayerAuthNotifier, PlayerAuthState>((ref) {
  return PlayerAuthNotifier(ref);
});
