// Player-specific authentication
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/authentication/models/player_signup_data.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/models/player_cricket_detail.dart';
import 'package:tracket/players/models/player_stats.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class PlayerAuthService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> signupPlayer({
    required PlayerSignupData data,
  }) async {
    try {
      final playerCricketDetail = PlayerCricketDetails(
        cricketRole: data.cricketRole,
        battingPosition: data.battingPosition,
        bowlingArm: data.bowlingArm,
        bowlingStyle: data.bowlingStyle,
        isPrivate: false,
        achievements: [],
        requestedTeams: [],
        teams: [],
        playerStats: PlayerStats(),
      );

      final player = Player(
        name: data.playerName,
        email: data.email,
        createdAt: Timestamp.now(),
        id: data.playerId,
        role: 'player',
        profileImageUrl: data.imageUrl,
        following: [],
        followingTeams: [],
        followers: [],
        playerCricketDetails: playerCricketDetail,
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
