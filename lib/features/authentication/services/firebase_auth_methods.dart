import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tracket/features/authentication/models/player_signup_data.dart';
import 'package:tracket/features/authentication/services/auth_service.dart';
import 'package:tracket/features/authentication/services/player_auth_services.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:uuid/uuid.dart';

class FirebaseAuthMethods extends AuthService {
  // Static instances
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  static const Uuid uuid = Uuid();

  void _authLog(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: 'TracketAuth.GoogleSignIn',
      error: error,
      stackTrace: stackTrace,
    );
    debugPrint('[TracketAuth.GoogleSignIn] $message');
    if (error != null) {
      debugPrint('[TracketAuth.GoogleSignIn][error] $error');
    }
  }

  Future<void> _reauthenticateWithGoogleIfNeeded(User user) async {
    final isGoogleUser =
        user.providerData.any((p) => p.providerId == 'google.com');
    if (!isGoogleUser) return;

    _authLog('Re-authentication with Google started for uid=${user.uid}');

    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      _authLog('Re-authentication cancelled by user for uid=${user.uid}');
      throw FirebaseAuthException(
        code: 'requires-recent-login',
        message: 'Reauthentication is required to delete this account.',
      );
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await user.reauthenticateWithCredential(credential);
    _authLog('Re-authentication with Google succeeded for uid=${user.uid}');
  }

  Future<void> _deleteSubCollection({
    required DocumentReference<Map<String, dynamic>> parentDoc,
    required String collectionName,
  }) async {
    final collectionSnap = await parentDoc.collection(collectionName).get();
    if (collectionSnap.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in collectionSnap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

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

  /// Fetches the current user's document snapshot from Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> get getUserSnap async {
    try {
      final snap = await _firestore
          .collection(FirestoreCollections.players)
          .doc(currentUserId)
          .get();

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

  /// Signs in the user with Google authentication
  Future<UserCredential?> signInWithGoogle() async {
    try {
      _authLog('Google sign-in flow started');
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _authLog('Google sign-in cancelled by user at account picker');
        return null;
      }

      _authLog(
        'Google account selected; hasEmail=${googleUser.email.isNotEmpty}',
      );

      final googleAuth = await googleUser.authentication;
      _authLog(
        'Google auth tokens received; hasIdToken=${googleAuth.idToken != null}, hasAccessToken=${googleAuth.accessToken != null}',
      );

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      _authLog(
        'Firebase sign-in succeeded; uid=${userCredential.user?.uid ?? 'unknown'}',
      );
      return userCredential;
    } on FirebaseAuthException catch (e, st) {
      _authLog(
        'FirebaseAuthException during Google sign-in; code=${e.code}; message=${e.message}',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } catch (e, st) {
      _authLog(
        'Unexpected exception during Google sign-in',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Checks whether a Firestore profile exists for the user
  static Future<bool> hasUserProfile(String userId) async {
    final profileDoc = await _firestore
        .collection(FirestoreCollections.players)
        .doc(userId)
        .get();
    return profileDoc.exists;
  }

  /// Creates player profile and starter stats from onboarding details
  Future<void> completePlayerOnboarding({
    required String playerName,
    required CricketRole role,
    required Position battingHand,
    required BowlingStyle bowlingStyle,
    required Position standardPosition,
  }) async {
    final user = currentUser;

    final email = user.email;
    if (email == null || email.trim().isEmpty) {
      throw StateError('Signed-in account has no email address');
    }

    final signupData = PlayerSignupData(
      playerId: user.uid,
      playerName: playerName.trim(),
      email: email.trim(),
      cricketRole: role,
      battingPosition: battingHand,
      bowlingStyle: bowlingStyle,
      bowlingArm: bowlingStyle == BowlingStyle.none ? null : standardPosition,
      imageUrl: user.photoURL ?? '',
    );

    final result = await PlayerAuthService.signupPlayer(data: signupData);
    if (result != TTextStrings.success) {
      throw StateError(result);
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

  /// Logs out the current user
  @override
  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteCurrentAccount() async {
    try {
      final user = currentUser;
      await _reauthenticateWithGoogleIfNeeded(user);

      final userDoc =
          _firestore.collection(FirestoreCollections.players).doc(user.uid);

      await _deleteSubCollection(
        parentDoc: userDoc,
        collectionName: FirestoreCollections.stats,
      );

      await _deleteSubCollection(
        parentDoc: userDoc,
        collectionName: FirestoreCollections.playerTeams,
      );

      await userDoc.delete();

      await user.delete();

      await _googleSignIn.signOut();
      try {
        await _auth.signOut();
      } catch (_) {}
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
