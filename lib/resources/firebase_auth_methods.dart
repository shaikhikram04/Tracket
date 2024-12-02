import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/models/player.dart';
import 'package:tracket/models/user.dart' as model;
import 'package:tracket/provider/verification_step.dart';
import 'package:tracket/screens/home.dart';
import 'package:uuid/uuid.dart';

class FirebaseAuthMethods {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static const uuid = Uuid();

  static User get currentUser => _auth.currentUser!;

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
        throw FirebaseAuthException(
          code: 'Email-is-already-in-use',
          message: 'Try another email or login with this email.',
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

        //* Signup user after email verification!
        final result = await signupUser(
          userId: user.uid,
          username: username,
          email: user.email!,
        );

        //! If fail in storing user data in firestore
        if (result != 'success' && context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result),
            ),
          );
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
  }) async {
    String result;

    try {
      final model.User user = model.User(
        email: email,
        username: username,
        role: 'user',
        createdAt: Timestamp.now(),
        userId: userId,
      );

      await _firestore.collection('users').doc(userId).set(user.toJson);
      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  static Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String result;
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  static Future<String> signupPlayer({
    required String playerName,
    required String email,
    required String password,
    required CricketRole cricketRole,
    required Position battingPosition,
    required BowingStyle bowlingStyle,
    Position? bowlingArm,
  }) async {
    String result;

    try {
      final playerCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String playerId = playerCred.user!.uid;

      final player = Player(
        playerName: playerName,
        email: email,
        role: cricketRole,
        battingPosition: battingPosition,
        bowlingArm: bowlingArm,
        bowlingStyle: bowlingStyle,
        createdAt: Timestamp.now(),
        id: playerId,
      );
      await _firestore.collection('players').doc(playerId).set(player.toJson);

      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  static Future<String> loginPlayer({
    required String email,
    required String password,
  }) async {
    String result;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }
}
