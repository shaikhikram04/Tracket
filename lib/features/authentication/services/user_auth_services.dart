// User-specific authentication
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class UserAuthService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> signupUser({
    required String userId,
    required String username,
    required String email,
    required String imageUrl,
  }) async {
    try {
      final user = Player.user(
        email: email,
        name: username,
        role: 'user',
        createdAt: Timestamp.now(),
        id: userId,
        profileImageUrl: imageUrl,
        following: [],
        followers: [],
        followingTeams: [],
      );

      await _firestore
          .collection(FirestoreCollections.players)
          .doc(userId)
          .set(user.toJsonForUser);
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }
}
