import 'package:tracket/players/models/player_cricket_detail.dart';
import 'package:tracket/players/models/player_details.dart';

enum BattingStatus {
  notOut('Not Out'),
  out('Out'),
  playing('Playing');

  const BattingStatus(this.description);
  final String description;
}

class MatchPlayerInfo {
  const MatchPlayerInfo({
    required this.playerId,
    required this.cricketRole,
    required this.playerName,
    required this.profileImageUrl,
    required this.longCricketRole,
    required this.battingStatus,
  });

  final String playerId;
  final String playerName;
  final CricketRole cricketRole;
  final String profileImageUrl;
  final String longCricketRole;
  final BattingStatus battingStatus;

  Map<String, dynamic> get toMap => {
        'playerId': playerId,
        'playerName': playerName,
        'cricketRole': cricketRole.name,
        'profileImageUrl': profileImageUrl,
        'longCricketRole': longCricketRole,
        'battingStatus': battingStatus.name,
      };

  static MatchPlayerInfo fromMap(Map<String, dynamic> snap) => MatchPlayerInfo(
        playerId: snap['playerId'],
        cricketRole: PlayerCricketDetails.getCricketRole(snap['cricketRole']),
        playerName: snap['playerName'],
        profileImageUrl: snap['profileImageUrl'],
        longCricketRole: snap['longCricketRole'],
        battingStatus: BattingStatus.values.firstWhere(
          (element) => element.name == snap['battingStatus'],
          orElse: () => BattingStatus.notOut,
        ),
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
          longCricketRole: player.longCricketRole,
          battingStatus: BattingStatus.notOut,
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
    BattingStatus? battingStatus,
  }) {
    return MatchPlayerInfo(
      playerId: playerId ?? this.playerId,
      cricketRole: cricketRole ?? this.cricketRole,
      playerName: playerName ?? this.playerName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      longCricketRole: longCricketRole ?? this.longCricketRole,
      battingStatus: battingStatus ?? this.battingStatus,
    );
  }
}
