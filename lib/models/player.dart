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
    required this.name,
    required this.dob,
    required this.role,
    required this.battingPosition,
    required this.bowingArm,
    required this.bowlingStyle,
    required this.playerStats,
  })  : id = uuid.v4(),
        totalTimesOut = 0,
        bestBalling = BowlingFigure(0, 0);

  final String id;
  final String name;
  final Timestamp dob;
  CricketRole role;
  Position battingPosition;
  int totalTimesOut;
  PlayerStats playerStats;
  BowlingFigure bestBalling = BowlingFigure(0, 0);
  Position? bowingArm;
  BowingStyle? bowlingStyle;

  double get battingAverage {
    if (totalTimesOut == 0) {
      return playerStats.totalRuns.toDouble();
    }

    return playerStats.totalRuns / totalTimesOut;
  }
}
