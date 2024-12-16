import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/models/player.dart';
import 'package:tracket/provider/verification_step.dart';
import 'package:tracket/screens/home.dart';
import 'package:tracket/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FirebaseAuthMethods {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static const uuid = Uuid();

  static User get currentUser => _auth.currentUser!;

  static String get currentUserId => currentUser.uid;

  static Future<User?> sendVerificationEmail(
    String email,
    String password,
  ) async {
    User? user;
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCred.user;
      await user?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        final userSnap = await _firestore
            .collection('players')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        String code;
        String message;
        if (userSnap.docs.first['role'] == 'user') {
          code = 'Email-is-already-in-use-as-user';
          message = 'Try another email or login as user with this email.';
        } else {
          code = 'Email-is-already-in-use-as-player';
          message = 'Try another email or login as player with this email.';
        }

        throw FirebaseAuthException(
          code: code,
          message: message,
        );
      }
    }

    return user;
  }

  static void checkEmailVerification({
    required User user,
    required String username,
    required WidgetRef ref,
    required BuildContext context,
    required String role,
    CricketRole? cricketRole,
    Position? battingPosition,
    BowlingStyle? bowlingStyle,
    Position? bowlingArm,
  }) {
    // Create a timer that can be cancelled
    Timer? verificationTimer;

    verificationTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await user.reload();
      user = currentUser;

      if (user.emailVerified) {
        // Cancel the timer first to stop further checks
        verificationTimer?.cancel();

        // Update verification steps with delays
        ref.read(verificationStepProvider.notifier).updateStep(2);
        await Future.delayed(const Duration(seconds: 1));

        final String result;
        if (role == 'user') {
          result = await signupUser(
            userId: user.uid,
            username: username,
            email: user.email!,
          );
        } else {
          result = await signupPlayer(
            playerId: user.uid,
            playerName: username,
            email: user.email!,
            cricketRole: cricketRole!,
            battingPosition: battingPosition!,
            bowlingStyle: bowlingStyle!,
            bowlingArm: bowlingArm,
          );
        }

        //! If fail in storing user data in firestore
        if (result != 'success' && context.mounted) {
          Navigator.of(context).pop();
          showSnackBar(result, context);
          ref.read(verificationStepProvider.notifier).updateStep(0);
          user.delete();
          return;
        } else {
          ref.read(verificationStepProvider.notifier).updateStep(3);
          await Future.delayed(const Duration(seconds: 1));

          // Navigate to home screen
          if (!context.mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
          ref.read(verificationStepProvider.notifier).updateStep(0);
        }
      }
    });

    // Optional: Set a maximum timeout for verification
    Future.delayed(const Duration(minutes: 3), () {
      verificationTimer?.cancel();
      if (!user.emailVerified) {
        user.delete();
      }
    });
  }

  static Future<String> signupUser({
    required String userId,
    required String username,
    required String email,
    String? imageUrl,
  }) async {
    String result;

    try {
      final Player user = Player.user(
        email: email,
        name: username,
        role: 'user',
        createdAt: Timestamp.now(),
        id: userId,
        profileImageUrl: imageUrl,
      );

      await _firestore
          .collection('players')
          .doc(userId)
          .set(user.toJsonForUser);
      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  static Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!userCred.user!.emailVerified && context.mounted) {
        showVerificationDialog(context, email);
        checkEmailVerification(
          user: userCred.user!,
          username: '',
          ref: ref,
          context: context,
          role: 'user',
        );
      } else {
        final userSnap = await _firestore
            .collection('players')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (userSnap.docs.first['role'] == 'player') {
          throw FirebaseAuthException(code: 'email-used-by-player');
        }

        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (error) {
      if (!context.mounted) return;
      if (error.code == 'user-not-found') {
        showAlertDialog(
          context,
          'User not found',
          'No user found with the provided email. Sign-up first!',
        );
      } else if (error.code == 'invalid-credential') {
        showSnackBar('Wrong email or password', context);
        rethrow;
      } else if (error.code == 'email-used-by-player') {
        _auth.currentUser!.delete();
        showSnackBar(
          'This email is used as a player. Please login as a player!',
          context,
        );
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<String> signupPlayer({
    required String playerId,
    required String playerName,
    required String email,
    required CricketRole cricketRole,
    required Position battingPosition,
    required BowlingStyle bowlingStyle,
    Position? bowlingArm,
    String? imageUrl,
  }) async {
    String result;

    try {
      final player = Player(
        name: playerName,
        email: email,
        cricketRole: cricketRole,
        battingPosition: battingPosition,
        bowlingArm: bowlingArm,
        bowlingStyle: bowlingStyle,
        createdAt: Timestamp.now(),
        id: playerId,
        role: 'player',
        profileImageUrl: imageUrl,
      );
      await _firestore
          .collection('players')
          .doc(playerId)
          .set(player.toJsonForPlayer);

      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  static Future<void> loginPlayer({
    required String email,
    required String password,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!userCred.user!.emailVerified && context.mounted) {
        showVerificationDialog(context, email);
        checkEmailVerification(
          user: userCred.user!,
          username: '',
          ref: ref,
          context: context,
          role: 'player',
        );
      } else {
        final userSnap = await _firestore
            .collection('players')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (userSnap.docs.first['role'] == 'user') {
          throw FirebaseAuthException(code: 'email-used-by-user');
        }

        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (error) {
      if (!context.mounted) return;
      if (error.code == 'user-not-found') {
        showAlertDialog(
          context,
          'User not found',
          'No user found with the provided email. Sign-up first!',
        );
      } else if (error.code == 'invalid-credential') {
        showSnackBar('Wrong email or password', context);
      } else if (error.code == 'email-used-by-user') {
        _auth.signOut();
        showSnackBar(
          'This email is used as a user. Please login as a player!',
          context,
        );
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<String> resetPassword(String email) async {
    String result;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      result = 'success';
    } catch (error) {
      result = error.toString();
    }

    return result;
  }

  static Future<String> logoutUser() async {
    String result;
    try {
      await _auth.signOut();
      result = 'success';
    } catch (e) {
      result = e.toString();
    }
    return result;
  }
}
