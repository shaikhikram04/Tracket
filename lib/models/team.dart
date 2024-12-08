import 'package:tracket/models/player.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Team {
  Team({
    required this.name,
    required this.shortName,
    required this.logoUrl,
    required this.playerList,
    required this.captain,
    required this.wicketKeeper,
    this.losses = 0,
    this.matchesPlayed = 0,
    this.tieCount = 0,
    this.wins = 0,
    this.rank = -1,
  }) : id = uuid.v4();

  final String id;
  final String name;
  final String shortName;
  final String logoUrl;
  final int rank;
  final List<Player> playerList;
  final Player captain;
  final Player wicketKeeper;
  final int matchesPlayed;
  final int wins;
  final int losses;
  final int tieCount;

  int get winningPercent {
    return ((wins / matchesPlayed) * 100).toInt();
  }
}
