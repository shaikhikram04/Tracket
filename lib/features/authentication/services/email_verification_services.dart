// Email verification service
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/authentication/models/player_signup_data.dart';
import 'package:tracket/features/authentication/models/verification_data.dart';
import 'package:tracket/features/authentication/providers/verification_step.dart';
import 'package:tracket/features/authentication/services/player_auth_services.dart';
import 'package:tracket/features/authentication/services/user_auth_services.dart';
import 'package:tracket/features/home/screens/home.dart';
import 'package:tracket/features/players/models/player_cricket_detail.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class EmailVerificationService {
  // Configuration constants
  static const Duration _verificationTimeout = Duration(minutes: 3);
  static const Duration _checkInterval = Duration(seconds: 3);


  /// Handles successful verification flow
  static Future<void> _onSuccess(Ref ref, BuildContext context) async {
    if (!context.mounted) return;

    ref.read(verificationStepProvider.notifier).updateStep(3);
    await Future.delayed(const Duration(seconds: 1));

    // Navigate to home screen only if context is still valid
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  /// Creates appropriate user record based on verification data
  static Future<void> _createUserRecord(VerificationData verificationData) async {
    try {
      final uid = verificationData.user.uid;
      final email = verificationData.user.email;

      if (email == null) {
        throw Exception('User email is null');
      }

      if (verificationData.role == TTextStrings.userRole) {
        await UserAuthService.signupUser(
          userId: uid,
          username: verificationData.username,
          email: email,
          imageUrl: verificationData.imageUrl,
        );
      } else {
        final playerData = PlayerSignupData(
          playerId: uid,
          playerName: verificationData.username,
          email: email,
          cricketRole: verificationData.cricketRole ?? CricketRole.allRounder,
          battingPosition: verificationData.battingPosition ?? Position.righty,
          bowlingStyle: verificationData.bowlingStyle ?? BowlingStyle.none,
          bowlingArm: verificationData.bowlingArm,
          imageUrl: verificationData.imageUrl,
        );
        await PlayerAuthService.signupPlayer(data: playerData);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Handles verification errors with appropriate cleanup
  static Future<void> _onError(String error, BuildContext context, User user) async {
    if (!context.mounted) return;

    // Close any dialogs that might be open
    Navigator.of(context).popUntil((route) => route.isFirst);

    // Show error to user
    THelperFunction.showErrorSnackBar(error, context);

    // Clean up by deleting unverified user
    try {
      await user.delete();
    } catch (e) {
      // Just log this error, we don't want to show multiple errors to the user
      debugPrint('Failed to delete unverified user: ${e.toString()}');
    }
  }

  /// Main verification method that monitors email verification status
  static Future<void> checkEmailVerification({
    required VerificationData data,
  }) async {
    Timer? verificationTimer;
    final completer = Completer<void>();

    try {
      // Set up periodic check for email verification
      verificationTimer = Timer.periodic(_checkInterval, (_) async {
        // Skip if already completed or context is no longer mounted
        if (completer.isCompleted || !data.context.mounted) {
          verificationTimer?.cancel();
          return;
        }

        try {
          await data.user.reload();
          final updatedUser = FirebaseAuth.instance.currentUser;

          if (updatedUser == null) {
            verificationTimer?.cancel();
            if (!completer.isCompleted) {
              completer.completeError('User no longer exists');
            }
            return;
          }

          if (updatedUser.emailVerified) {
            verificationTimer?.cancel();

            // Create user records in database
            await _createUserRecord(data);

            // Complete verification flow if context is still mounted
            if (data.context.mounted) {
              await _onSuccess(data.ref, data.context);
              data.ref.read(verificationStepProvider.notifier).resetStep();
              completer.complete();
            }
          }
        } on FirebaseAuthException catch (e) {
          verificationTimer?.cancel();
          if (!completer.isCompleted) {
            completer.completeError(_mapFirebaseError(e));
          }
        } catch (e) {
          verificationTimer?.cancel();
          if (!completer.isCompleted) {
            completer.completeError(e.toString());
          }
        }
      });

      // Set verification timeout
      Future.delayed(_verificationTimeout, () {
        if (!completer.isCompleted) {
          verificationTimer?.cancel();
          completer.completeError(TTextStrings.verificationTimeout);
        }
      });

      // Handle completion or errors
      await completer.future;
    } catch (error) {
      if (data.context.mounted) {
        await _onError(error.toString(), data.context, data.user);
        data.ref.read(verificationStepProvider.notifier).resetStep();
      }
    } finally {
      // Ensure timer is cancelled in all cases
      verificationTimer?.cancel();
    }
  }

  /// Maps Firebase auth errors to user-friendly messages
  static String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'network-request-failed':
        return TTextStrings.networkErrorMessage;
      case 'user-not-found':
        return 'User account no longer exists.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? TTextStrings.unexpectedError;
    }
  }
}
