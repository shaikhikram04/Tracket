import 'package:tracket/players/models/player.dart';

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
        cricketRole: snap['cricketRole'],
        playerName: snap['playerName'],
        profileImageUrl: snap['profileImageUrl'],
      );
}
