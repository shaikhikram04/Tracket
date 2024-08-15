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
  });

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
}
