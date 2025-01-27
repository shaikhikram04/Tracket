import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/models/player_details.dart';

class MatchPlayerInfo {
  const MatchPlayerInfo({
    required this.playerId,
    required this.cricketRole,
    required this.playerName,
    required this.profileImageUrl,
  });

  final String playerId;
  final String playerName;
  final CricketRole cricketRole;
  final String profileImageUrl;

  Map<String, dynamic> get toMap => {
        'playerId': playerId,
        'playerName': playerName,
        'cricketRole': cricketRole.name,
        'profileImageUrl': profileImageUrl,
      };

  static MatchPlayerInfo fromMap(Map<String, dynamic> snap) => MatchPlayerInfo(
        playerId: snap['playerId'],
        cricketRole: Player.getCricketRole(snap['cricketRole']),
        playerName: snap['playerName'],
        profileImageUrl: snap['profileImageUrl'],
      );

  static List<MatchPlayerInfo> fromPlayerDetailList(
      List<PlayerDetails> players) {
    return players.map(
      (player) {
        return MatchPlayerInfo(
          playerId: player.id,
          cricketRole: player.cricketRole,
          playerName: player.name,
          profileImageUrl: player.imageUrl,
        );
      },
    ).toList();
  }

  MatchPlayerInfo copyWith({
    String? playerId,
    String? playerName,
    CricketRole? cricketRole,
    String? profileImageUrl,
  }) {
    return MatchPlayerInfo(
      playerId: playerId ?? this.playerId,
      cricketRole: cricketRole ?? this.cricketRole,
      playerName: playerName ?? this.playerName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
