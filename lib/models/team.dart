

import 'dart:ui';
import 'package:tracket/models/player.dart';

class Team {
  Team({
    required this.name,
    required this.shortName,
    required this.logo,
    required this.playerList,
    required this.captain,
    required this.wicketKeeper,
    this.matchesPlayed = 0,
    this.wins = 0,
    this.losses = 0,
    this.tieCount = 0,
  });

  final String name;
  final String shortName;
  final Image logo;
  List<Player> playerList;
  Player captain;
  Player wicketKeeper;
  int matchesPlayed;
  int wins;
  int losses;
  int tieCount;
}
