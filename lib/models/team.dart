import 'dart:ui';

import 'package:tracket/models/player.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Team {
  Team({
    required this.name,
    required this.shortName,
    required this.logo,
    required this.playerList,
    required this.captain,
    required this.wicketKeeper,
  }) : id = uuid.v4();

  final String id;
  final String name;
  final String shortName;
  final Image logo;
  List<Player> playerList;
  Player captain;
  Player wicketKeeper;
  int matchesPlayed = 0;
  int wins = 0;
  int losses = 0;
  int tieCount = 0;

  int get winningPercent {
    return ((wins / matchesPlayed) * 100).toInt();
  }
}
