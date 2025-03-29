// Player-specific authentication
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/authentication/models/player_signup_data.dart';
import 'package:tracket/players/models/all_format_stats.dart';
import 'package:tracket/players/models/bowling_stats.dart';
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
      final cantBowl = data.cricketRole == CricketRole.batsman ||
          data.cricketRole == CricketRole.wicketKeeper;

      final playerCricketDetail = PlayerCricketDetails(
        cricketRole: data.cricketRole,
        battingPosition: data.battingPosition,
        bowlingArm: data.bowlingArm,
        bowlingStyle: data.bowlingStyle,
        isPrivate: false,
        achievements: [],
        requestedTeams: [],
        teams: [],
        allFormatStats: AllFormatStats(
          over5: PlayerStats(
            bowlingStats: cantBowl ? null : const BowlingStats(),
          ),
          over10: PlayerStats(
            bowlingStats: cantBowl ? null : const BowlingStats(),
          ),
          over20: PlayerStats(
            bowlingStats: cantBowl ? null : const BowlingStats(),
          ),
          over50: PlayerStats(
            bowlingStats: cantBowl ? null : const BowlingStats(),
          ),
          test: PlayerStats(
            bowlingStats: cantBowl ? null : const BowlingStats(),
          ),
        ),
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

      final playerDocRef = _firestore
          .collection(FirestoreCollections.players)
          .doc(data.playerId);

      await playerDocRef.set(player.toJsonForPlayer);

      final playerStatsCollectionRef =
          playerDocRef.collection(FirestoreCollections.stats);

      await playerStatsCollectionRef
          .doc("over5")
          .set(playerCricketDetail.allFormatStats.over5.toJson);

      await playerStatsCollectionRef
          .doc("over10")
          .set(playerCricketDetail.allFormatStats.over10.toJson);

      await playerStatsCollectionRef
          .doc("over20")
          .set(playerCricketDetail.allFormatStats.over20.toJson);

      await playerStatsCollectionRef
          .doc("over50")
          .set(playerCricketDetail.allFormatStats.over50.toJson);

      await playerStatsCollectionRef
          .doc("test")
          .set(playerCricketDetail.allFormatStats.test.toJson);

      return 'success';
    } catch (e) {
      return e.toString();
    }
  }
}
