// Player-specific authentication
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/authentication/models/player_signup_data.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/models/player_stats.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class PlayerAuthService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> signupPlayer({
    required PlayerSignupData data,
  }) async {
    try {
      final player = Player(
        name: data.playerName,
        email: data.email,
        cricketRole: data.cricketRole,
        battingPosition: data.battingPosition,
        bowlingArm: data.bowlingArm,
        bowlingStyle: data.bowlingStyle,
        createdAt: Timestamp.now(),
        id: data.playerId,
        role: 'player',
        profileImageUrl: data.imageUrl,
        teams: [],
        playerStats: PlayerStats(),
        achievements: [],
        following: [],
        followingTeams: [],
        followers: [],
        isPrivate: false,
      );

      await _firestore
          .collection(FirestoreCollections.players)
          .doc(data.playerId)
          .set(player.toJsonForPlayer);

      return 'success';
    } catch (e) {
      return e.toString();
    }
  }
}
