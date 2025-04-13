import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/authentication/models/verification_data.dart';
import 'package:tracket/features/authentication/services/auth_service.dart';
import 'package:tracket/features/authentication/services/email_verification_services.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/screens/home.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FirebaseAuthMethods extends AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static const uuid = Uuid();

  @override
  User get currentUser {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user found');
    }
    return user;
  }

  @override
  String get currentUserId => currentUser.uid;

  @override
  Future<User?> sendVerificationEmail(
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
        final role = await FirebaseAuthMethods.getUserRole(email);

        String code;
        String message;
        if (role == 'user') {
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

  Future<DocumentSnapshot<Map<String, dynamic>>> get getUserSnap async {
    var snap = await _firestore
        .collection(FirestoreCollections.players)
        .doc(currentUserId)
        .get();

    return snap;
  }

  Future<Player> get getUserDetail async {
    final snap = await getUserSnap;

    QuerySnapshot? playerTeamsSnap;
    if (snap.data()!['role'] == 'player') {
      playerTeamsSnap = await _firestore
          .collection(FirestoreCollections.players)
          .doc(currentUserId)
          .collection(FirestoreCollections.playerTeams)
          .get();
      return Player.fromSeed(snap.data()!, playerTeamsSnap.docs);
    } else {
      return Player.fromSeedForUser(snap.data()!);
    }
  }

  @override
  Future<void>  login({
    required String email,
    required String password,
    required BuildContext context,
    required Ref ref,
    required String expectedRole,
  }) async {
    final oponentRole = expectedRole == 'user' ? 'player' : 'user';
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!userCred.user!.emailVerified && context.mounted) {
        showVerificationDialog(context, email);
        final verificationData = VerificationData(
          user: userCred.user!,
          username: '',
          ref: ref,
          context: context,
          role: expectedRole,
          imageUrl: '',
        );
        EmailVerificationService.checkEmailVerification(data: verificationData);
        return;
      }

      final role = await getUserRole(email);

      if (role != expectedRole) {
        throw FirebaseAuthException(code: 'email-used-by-$oponentRole');
      }

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
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
      } else if (error.code == 'email-used-by-$oponentRole') {
        _auth.signOut();
        showSnackBar(
          'This email is used as a $oponentRole. Please login as a $oponentRole!',
          context,
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      showSnackBar(error.toString(), context);
    }
  }

  @override
  Future<String> resetPassword(String email) async {
    String result;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      result = 'success';
    } catch (error) {
      result = error.toString();
    }

    return result;
  }

  static Future<String> getUserRole(String email) async {
    final userSnap = await _firestore
        .collection(FirestoreCollections.players)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return userSnap.docs.first.data()['role'] as String;
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
