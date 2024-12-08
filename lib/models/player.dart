import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/models/player_stats.dart';

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

enum BowlingStyle {
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

class Player {
  Player(
     {
    required this.role,
    required this.id,
    required this.playerName,
    required this.email,
    required this.profileImageUrl,
    required this.cricketRole,
    required this.battingPosition,
    required this.bowlingArm,
    required this.bowlingStyle,
    required this.createdAt,
  })  : totalTimesOut = 0,
        bestBalling = BowlingFigure(0, 0),
        playerStats = PlayerStats();

  final String id;
  final String email;
  final String playerName;
  final String role;
  final CricketRole cricketRole;
  final Position battingPosition;
  final int totalTimesOut;
  final PlayerStats playerStats;
  final String? profileImageUrl;
  BowlingFigure bestBalling = BowlingFigure(0, 0);
  Position? bowlingArm;
  BowlingStyle bowlingStyle;
  final Timestamp createdAt;

  double get battingAverage {
    if (totalTimesOut == 0) {
      return playerStats.totalRuns.toDouble();
    }

    return playerStats.totalRuns / totalTimesOut;
  }

  Map<String, dynamic> get toJson => {
        'playerId': id,
        'email': email,
        'playerName': playerName,
        'role': role,
        'profileImageUrl':profileImageUrl,
        'cricketRole': cricketRole.name,
        'battingPosition': battingPosition.name,
        'totalTimesOut': totalTimesOut,
        'bowlingArm': bowlingArm?.name,
        'bowlingStyle': bowlingStyle.name,
        'createdAt': createdAt,
        'bestBalling': [bestBalling.runGiven, bestBalling.ballDelivered],
        ...playerStats.toJson,
      };
}
