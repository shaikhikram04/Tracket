import 'package:tracket/matches/models/match_player_info.dart';

class MatchTeamInfo {
  MatchTeamInfo({
    required this.teamId,
    required this.captainId,
    required this.logoUrl,
    required this.shortName,
    required this.teamName,
    required this.wicketkeeperId,
    required this.teamPlayers,
  });

  final String teamId;
  final String teamName;
  final String shortName;
  final String logoUrl;
  final String captainId;
  final String wicketkeeperId;
  List<MatchPlayerInfo> teamPlayers;

  Map<String, dynamic> get toMap => {
        'teamId': teamId,
        'teamName': teamName,
        'shortName': shortName,
        'logoUrl': logoUrl,
        'captainId': captainId,
        'wicketkeeperId': wicketkeeperId,
        'teamPlayers': teamPlayers,
      };

  static MatchTeamInfo fromMap(Map<String, dynamic> snap) => MatchTeamInfo(
        teamId: snap['teamId'],
        captainId: snap['captainId'],
        logoUrl: snap['logoUrl'],
        shortName: snap['shortName'],
        teamName: snap['teamName'],
        wicketkeeperId: snap['wicketkeeperId'],
        teamPlayers: snap['teamPlayers'],
      );

  // Utility methods
  String get displayName => shortName.toUpperCase();

  bool isPlayerCaptain(String playerId) => playerId == captainId;

  bool isPlayerWicketkeeper(String playerId) => playerId == wicketkeeperId;

  void setPlayers(List<MatchPlayerInfo> players) {
    teamPlayers = players;
  }

  MatchTeamInfo copyWith({
    String? teamId,
    String? teamName,
    String? shortName,
    String? logoUrl,
    String? captainId,
    String? wicketkeeperId,
    List<MatchPlayerInfo>? teamPlayers,
  }) =>
      MatchTeamInfo(
        teamId: teamId ?? this.teamId,
        captainId: captainId ?? this.captainId,
        logoUrl: logoUrl ?? this.logoUrl,
        shortName: shortName ?? this.shortName,
        teamName: teamName ?? this.teamName,
        wicketkeeperId: wicketkeeperId ?? this.wicketkeeperId,
        teamPlayers: teamPlayers ?? this.teamPlayers,
      );
}
