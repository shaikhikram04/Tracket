class MatchTeamInfo {
  const MatchTeamInfo({
    required this.teamId,
    required this.captainId,
    required this.logoUrl,
    required this.shortName,
    required this.teamName,
    required this.wicketkeeperId,
  });

  final String teamId;
  final String teamName;
  final String shortName;
  final String logoUrl;
  final String captainId;
  final String wicketkeeperId;

  Map<String, dynamic> get toMap => {
        'teamId': teamId,
        'teamName': teamName,
        'shortName': shortName,
        'logoUrl': logoUrl,
        'captainId': captainId,
        'wicketkeeperId': wicketkeeperId,
      };

  static MatchTeamInfo fromMap(Map<String, dynamic> snap) => MatchTeamInfo(
        teamId: snap['teamId'],
        captainId: snap['captainId'],
        logoUrl: snap['logoUrl'],
        shortName: snap['shortName'],
        teamName: snap['teamName'],
        wicketkeeperId: snap['wicketkeeperId'],
      );
}
