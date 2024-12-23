class Team {
  Team({
    required this.id,
    required this.name,
    required this.shortName,
    required this.logoUrl,
    required this.playersList,
    required this.achievements,
    required this.following,
    required this.followers,
    this.captainId,
    this.wicketKeeperId,
    required this.createdBy,
    this.losses = 0,
    this.matchesPlayed = 0,
    this.tieCount = 0,
    this.wins = 0,
    this.rank = -1,
  });

  final String id;
  final String name;
  final String shortName;
  final String createdBy;
  final String? logoUrl;
  final int rank;
  final List<Map> playersList;
  final String? captainId;
  final String? wicketKeeperId;
  final int matchesPlayed;
  final int wins;
  final int losses;
  final int tieCount;
  final List<String> achievements;
  final List<String> following;
  final List<String> followers;

  int get winningPercent {
    return ((wins / matchesPlayed) * 100).toInt();
  }

  Map<String, dynamic> get toJson => {
        'id': id,
        'teamName': name,
        'shortName': shortName,
        'createdBy': createdBy,
        'logoUrl': logoUrl,
        'rank': rank,
        'playersList': playersList,
        'captainId': captainId,
        'wicketKeeperId': wicketKeeperId,
        'matches': matchesPlayed,
        'wins': wins,
        'losses': losses,
        'tie': tieCount,
        'achievements': achievements,
        'following': following,
        'followers': followers,
      };

  static Team formSeed(Map<String, dynamic> snap) => Team(
        id: snap['id'],
        name: snap['teamName'],
        shortName: snap['shortName'],
        logoUrl: snap['logoUrl'],
        playersList: List.from(snap['playersList']),
        createdBy: snap['createdBy'],
        captainId: snap['captainId'],
        losses: snap['losses'],
        matchesPlayed: snap['matches'],
        rank: snap['rank'],
        tieCount: snap['tie'],
        wicketKeeperId: snap['wicketKeeperId'],
        wins: snap['wins'],
        achievements: snap['achievements'],
        following: snap['following'],
        followers: snap['followers'],
      );
}
