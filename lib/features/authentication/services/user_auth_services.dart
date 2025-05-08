// User-specific authentication
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class UserAuthService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> signupUser({
    required String userId,
    required String username,
    required String email,
    String imageUrl = "",
  }) async {
    try {
      // Create user document
      final user = _createUserDocument(
        userId: userId,
        username: username,
        email: email,
        imageUrl: imageUrl,
      );

      // Write user document to Firestore
      await _saveUserData(userId, user);

      return TTextStrings.success;
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      debugPrint('Firebase error during user signup: ${e.code} - ${e.message}');
      return e.message ?? 'Firebase error: ${e.code}';
    } catch (e) {
      // Handle general errors
      debugPrint('Error during user signup: $e');
      return e.toString();
    }
  }

  /// Creates a user document from the provided parameters
  static Player _createUserDocument({
    required String userId,
    required String username,
    required String email,
    required String imageUrl,
  }) {
    return Player.user(
      email: email,
      name: username,
      role: TTextStrings.userRole,
      createdAt: Timestamp.now(),
      id: userId,
      profileImageUrl: imageUrl,
      following: const [],
      followers: const [],
      followingTeams: const [],
    );
  }

  /// Saves user data to Firestore
  ///
  /// Uses error handling and retry logic for better reliability
  static Future<void> _saveUserData(String userId, Player user) async {
    const int maxRetries = 3;
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        // Get reference to the user document
        final DocumentReference userDocRef = _firestore.collection(FirestoreCollections.players).doc(userId);

        // Write user data to Firestore with merge option
        // to avoid overwriting existing data if the document exists
        await userDocRef.set(user.toJsonForUser, SetOptions(merge: true));

        // Success, exit the retry loop
        return;
      } on FirebaseException catch (e) {
        attempts++;

        // If this was the last attempt, rethrow the error
        if (attempts >= maxRetries) {
          rethrow;
        }

        // For network errors, wait before retrying
        if (e.code == 'network-request-failed') {
          await Future.delayed(Duration(seconds: attempts));
        } else {
          // For other errors, rethrow immediately
          rethrow;
        }
      }
    }
  }
}
