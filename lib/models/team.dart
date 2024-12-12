import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Team {
  Team({
    required this.name,
    required this.shortName,
    required this.logoUrl,
    required this.playersList,
    this.captainId,
    this.wicketKeeperId,
    required this.createdBy,
    this.losses = 0,
    this.matchesPlayed = 0,
    this.tieCount = 0,
    this.wins = 0,
    this.rank = -1,
  }) : id = uuid.v4();

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
        'wins': wins,
        'losses': losses,
        'tie': tieCount,
      };
}
