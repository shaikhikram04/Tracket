import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/authentication/models/verification_data.dart';
import 'package:tracket/features/authentication/services/auth_service.dart';
import 'package:tracket/features/authentication/services/email_verification_services.dart';
import 'package:tracket/features/home/screens/home.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:uuid/uuid.dart';

class FirebaseAuthMethods extends AuthService {
  // Static instances
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const Uuid uuid = Uuid();

  // Error message constants
  static const String _invalidRoleError = 'This email is used as a %s. Please login as a %s!';

  @override
  User get currentUser {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError(TTextStrings.noAuthenticationUser);
    }
    return user;
  }

  /// Gets the current user's ID
  @override
  String get currentUserId => currentUser.uid;

  //* Sends a verification email to a new user
  ///
  /// Returns the created [User] if successful, or throws an exception
  @override
  Future<User?> sendVerificationEmail(
    String email,
    String password,
  ) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user;
      if (user == null) {
        throw StateError('Failed to create user account');
      }

      await user.sendEmailVerification();
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == TTextStrings.emailAlreadyInUse) {
        final role = await getUserRole(email);

        final String code;
        final String message;
        if (role == TTextStrings.userRole) {
          code = TTextStrings.emailUsedByUserCode;
          message = TTextStrings.emailUsedByUser;
        } else {
          code = TTextStrings.emailUsedByPlayerCode;
          message = TTextStrings.emailUsedByPlayer;
        }

        throw FirebaseAuthException(
          code: code,
          message: message,
        );
      }
      // Re-throw other Firebase exceptions
      rethrow;
    } catch (e) {
      // Re-throw general exceptions
      rethrow;
    }
  }

  /// Fetches the current user's document snapshot from Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> get getUserSnap async {
    try {
      final snap = await _firestore.collection(FirestoreCollections.players).doc(currentUserId).get();

      if (!snap.exists) {
        throw StateError('User document does not exist');
      }

      return snap;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets detailed player information for the current user
  Future<Player> get getUserDetail async {
    try {
      final snap = await getUserSnap;
      final userData = snap.data();

      if (userData == null) {
        throw StateError('User data is null');
      }

      if (userData['role'] == TTextStrings.playerRole) {
        return await _getPlayerDetails(userData);
      } else {
        return Player.fromSeedForUser(userData);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Helper method to fetch player-specific details
  Future<Player> _getPlayerDetails(Map<String, dynamic> userData) async {
    try {
      // Get player teams
      final playerTeamsSnap = await _firestore
          .collection(FirestoreCollections.players)
          .doc(currentUserId)
          .collection(FirestoreCollections.playerTeams)
          .get();

      // Get all format statistics
      final allFormatStatsSnap = await _firestore
          .collection(FirestoreCollections.players)
          .doc(currentUserId)
          .collection(FirestoreCollections.stats)
          .get();

      final allFormatStatsDoc = allFormatStatsSnap.docs;
      final allFormatStats = <String, dynamic>{};

      for (final stats in allFormatStatsDoc) {
        allFormatStats.addAll({stats.id: stats.data()});
      }

      return Player.fromSeed(userData, playerTeamsSnap.docs, allFormatStats);
    } catch (e) {
      rethrow;
    }
  }

  /// Handles user login
  ///
  /// Manages email verification and role-specific validation
  @override
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
    required Ref ref,
    required String expectedRole,
  }) async {
    if (!context.mounted) return;

    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user;
      if (user == null) {
        throw StateError('Login succeeded but user is null');
      }

      // Handle non-verified email
      if (!user.emailVerified) {
        if (!context.mounted) return;

        await _handleUnverifiedUser(context, ref, email, user, expectedRole);
        return;
      }

      // Verify user has the expected role
      await _verifyUserRole(email, expectedRole, context);

      // Navigate to home screen
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (error) {
      final opponentRole = expectedRole == TTextStrings.userRole ? TTextStrings.playerRole : TTextStrings.userRole;
      if (!context.mounted) return;
      if (error.code == TTextStrings.userNotFound) {
        THelperFunction.showAlertDialog(
          context,
          TTextStrings.userNotFound,
          TTextStrings.userNotFoundMessage,
        );
      } else if (error.code == TTextStrings.invalidCredentialCode) {
        THelperFunction.showSnackBar(TTextStrings.wrongEmailOrPassword, context);
        rethrow;
      } else if (error.code == 'email-used-by-$opponentRole') {
        _auth.signOut();
        THelperFunction.showSnackBar(
          'This email is used as a $opponentRole. Please login as a $opponentRole!',
          context,
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      THelperFunction.showSnackBar(error.toString(), context);
    }
  }

  /// Handles unverified user login flow
  Future<void> _handleUnverifiedUser(
      BuildContext context, Ref ref, String email, User user, String expectedRole) async {
    if (!context.mounted) return;

    THelperFunction.showVerificationDialog(context, email);

    final verificationData = VerificationData(
      user: user,
      username: '',
      ref: ref,
      context: context,
      role: expectedRole,
      imageUrl: '',
    );

    await EmailVerificationService.checkEmailVerification(data: verificationData);
  }

  /// Verifies that the user has the expected role
  Future<void> _verifyUserRole(String email, String expectedRole, BuildContext context) async {
    final role = await getUserRole(email);

    if (role != expectedRole) {
      final opponentRole = expectedRole == TTextStrings.userRole ? TTextStrings.playerRole : TTextStrings.userRole;

      await _auth.signOut();

      if (!context.mounted) return;

      THelperFunction.showSnackBar(
        _invalidRoleError.replaceAll('%s', opponentRole),
        context,
      );

      throw FirebaseAuthException(code: 'email-used-by-$opponentRole');
    }
  }

  /// Sends a password reset email
  @override
  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return TTextStrings.success;
    } on FirebaseAuthException catch (e) {
      return e.message ?? e.code;
    } catch (error) {
      return error.toString();
    }
  }

  /// Gets the role associated with an email address
  static Future<String> getUserRole(String email) async {
    try {
      final userSnap =
          await _firestore.collection(FirestoreCollections.players).where('email', isEqualTo: email).limit(1).get();

      if (userSnap.docs.isEmpty) {
        throw StateError('User with email $email not found');
      }

      return userSnap.docs.first.data()['role'] as String;
    } catch (e) {
      rethrow;
    }
  }


   /// Logs out the current user
  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
