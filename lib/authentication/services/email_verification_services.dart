// Email verification service
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/authentication/models/player_signup_data.dart';
import 'package:tracket/authentication/models/verification_data.dart';
import 'package:tracket/authentication/providers/auth_screen_size.dart';
import 'package:tracket/authentication/providers/verification_step.dart';
import 'package:tracket/authentication/services/player_auth_services.dart';
import 'package:tracket/authentication/services/user_auth_services.dart';
import 'package:tracket/screens/home.dart';
import 'package:tracket/utils/utils.dart';

class EmailVerificationService {
  static const _verificationTimeout = Duration(minutes: 3);
  static const _checkInterval = Duration(seconds: 3);

  static Future<void> _onSuccess(Ref ref, BuildContext context) async {
    ref.read(verificationStepProvider.notifier).nextStep();
    await Future.delayed(const Duration(seconds: 1));

    // Navigate to home screen
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  static Future<void> _handleVerifiedUser(
      VerificationData verificationData) async {
    // Update verification steps with delays
    verificationData.ref.read(verificationStepProvider.notifier).nextStep();
    await Future.delayed(const Duration(seconds: 1));

    try {
      if (verificationData.role == 'user') {
        await UserAuthService.signupUser(
          userId: verificationData.user.uid,
          username: verificationData.username,
          email: verificationData.user.email!,
          imageUrl: verificationData.imageUrl,
        );
      } else {
        final data = PlayerSignupData(
          playerId: verificationData.user.uid,
          playerName: verificationData.username,
          email: verificationData.user.email!,
          cricketRole: verificationData.cricketRole!,
          battingPosition: verificationData.battingPosition!,
          bowlingStyle: verificationData.bowlingStyle!,
          bowlingArm: verificationData.bowlingArm,
          imageUrl: verificationData.imageUrl,
        );
        await PlayerAuthService.signupPlayer(data: data);
      }
    } catch (e) {
      rethrow;
    }
  }

  static void _onError(String error, BuildContext context, User user) {
    Navigator.of(context).pop();
    showSnackBar(error, context);
    user.delete();
  }

  static Future<void> checkEmailVerification({
    required VerificationData data,
  }) async {
    Timer? verificationTimer;
    bool isCompleted = false;

    verificationTimer = Timer.periodic(_checkInterval, (_) async {
      if (isCompleted) return;

      try {
        await data.user.reload();
        final updatedUser = FirebaseAuth.instance.currentUser;

        if (updatedUser?.emailVerified ?? false) {
          await _handleVerifiedUser(data);
          if (!data.context.mounted) return;
          await _onSuccess(data.ref, data.context);
        }
      } catch (e) {
        if (!data.context.mounted) return;
        _onError(e.toString(), data.context, data.user);
      } finally {
        data.ref.read(authScreenSizeProvider.notifier).resetSize();
        data.ref.read(verificationStepProvider.notifier).resetStep();
        verificationTimer?.cancel();
        isCompleted = true;
      }
    });

    // Set verification timeout
    Future.delayed(_verificationTimeout, () {
      if (!isCompleted) {
        verificationTimer?.cancel();
        if (!data.context.mounted) return;
        _onError('Verification timeout', data.context, data.user);
      }
    });
  }
}
