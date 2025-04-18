// Player-specific authentication
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/features/authentication/models/player_signup_data.dart';
import 'package:tracket/features/players/models/all_format_stats.dart';
import 'package:tracket/features/players/models/bowling_stats.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/features/players/models/player_cricket_detail.dart';
import 'package:tracket/features/players/models/player_stats.dart';
import 'package:tracket/utils/constants/text_strings.dart';
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
        role: TTextStrings.playerRole,
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
          .doc(TTextStrings.over5Key)
          .set(playerCricketDetail.allFormatStats.over5.toJson);

      await playerStatsCollectionRef
          .doc(TTextStrings.over10Key)
          .set(playerCricketDetail.allFormatStats.over10.toJson);

      await playerStatsCollectionRef
          .doc(TTextStrings.over20Key)
          .set(playerCricketDetail.allFormatStats.over20.toJson);

      await playerStatsCollectionRef
          .doc(TTextStrings.over50Key)
          .set(playerCricketDetail.allFormatStats.over50.toJson);

      await playerStatsCollectionRef
          .doc(TTextStrings.testKey)
          .set(playerCricketDetail.allFormatStats.test.toJson);

      return TTextStrings.success;
    } catch (e) {
      return e.toString();
    }
  }
}
