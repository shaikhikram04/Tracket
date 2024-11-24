import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/models/player_stats.dart';
import 'package:uuid/uuid.dart';

enum CricketRole {
  batsman,
  bowler,
  allRounder,
  wicketKeeper,
}

enum Position {
  righty,
  lefty,
}

enum BowingStyle {
  none,
  fast,
  mediumFast,
  legSpin,
  offSpin,
  chinaMan,
}

class BowlingFigure {
  int runGiven;
  int ballDelivered;
  BowlingFigure(
    this.runGiven,
    this.ballDelivered,
  );
}

const uuid = Uuid();

class Player {
  Player({
    required this.playerName,
    required this.email,
    required this.role,
    required this.battingPosition,
    required this.bowingArm,
    required this.bowlingStyle,
    required this.createdAt,
  })  : id = uuid.v4(),
        totalTimesOut = 0,
        bestBalling = BowlingFigure(0, 0),
        playerStats = PlayerStats();

  final String id;
  final String email;
  final String playerName;
  final CricketRole role;
  final Position battingPosition;
  final int totalTimesOut;
  final PlayerStats playerStats;
  BowlingFigure bestBalling = BowlingFigure(0, 0);
  Position? bowingArm;
  BowingStyle bowlingStyle;
  final Timestamp createdAt;

  double get battingAverage {
    if (totalTimesOut == 0) {
      return playerStats.totalRuns.toDouble();
    }

    return playerStats.totalRuns / totalTimesOut;
  }
}
