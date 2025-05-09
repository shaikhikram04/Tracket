import 'package:tracket/features/players/models/player_cricket_detail.dart';
import 'package:tracket/features/players/models/player_details.dart';
import 'package:tracket/utils/constants/enums.dart';

class MatchPlayerInfo {
  const MatchPlayerInfo({
    required this.playerId,
    required this.cricketRole,
    required this.playerName,
    required this.profileImageUrl,
    required this.longCricketRole,
  });

  final String playerId;
  final String playerName;
  final CricketRole cricketRole;
  final String profileImageUrl;
  final String longCricketRole;

  Map<String, dynamic> get toMap => {
        'playerId': playerId,
        'playerName': playerName,
        'cricketRole': cricketRole.name,
        'profileImageUrl': profileImageUrl,
        'longCricketRole': longCricketRole,
      };

  static MatchPlayerInfo fromMap(Map<String, dynamic> snap) => MatchPlayerInfo(
        playerId: snap['playerId'],
        cricketRole: PlayerCricketDetails.getCricketRole(snap['cricketRole']),
        playerName: snap['playerName'],
        profileImageUrl: snap['profileImageUrl'],
        longCricketRole: snap['longCricketRole'],
      );

  static List<MatchPlayerInfo> fromPlayerDetailList(List<PlayerDetails> players) {
    return players.map(
      (player) {
        return MatchPlayerInfo(
          playerId: player.id,
          cricketRole: player.cricketRole,
          playerName: player.name,
          profileImageUrl: player.imageUrl,
          longCricketRole: player.longCricketRole,
        );
      },
    ).toList();
  }

  MatchPlayerInfo copyWith({
    String? playerId,
    String? playerName,
    CricketRole? cricketRole,
    String? profileImageUrl,
    String? longCricketRole,
  }) {
    return MatchPlayerInfo(
      playerId: playerId ?? this.playerId,
      cricketRole: cricketRole ?? this.cricketRole,
      playerName: playerName ?? this.playerName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      longCricketRole: longCricketRole ?? this.longCricketRole,
    );
  }
}
