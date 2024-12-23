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
  final String id;
  final String email;
  final String name;
  final String role;
  final String? profileImageUrl;
  final int? matchesPlayed;
  final List<String>? teamsId;
  final List<String>? achievements;
  final CricketRole? cricketRole;
  final Position? battingPosition;
  final int? totalTimesOut;
  final PlayerStats? playerStats;
  BowlingFigure? bestBalling = BowlingFigure(0, 0);
  final Position? bowlingArm;
  final BowlingStyle? bowlingStyle;
  final Timestamp createdAt;

  Player({
    required this.role,
    required this.id,
    required this.name,
    required this.email,
    required this.achievements,
    required this.teamsId,
    required this.profileImageUrl,
    required this.cricketRole,
    required this.battingPosition,
    required this.bowlingArm,
    required this.bowlingStyle,
    required this.createdAt,
    required this.bestBalling,
    required this.playerStats,
    required this.matchesPlayed,
    this.totalTimesOut = 0,
  });

  Player.user({
    required this.role,
    required this.id,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.createdAt,
  })  : battingPosition = null,
        bestBalling = null,
        bowlingArm = null,
        bowlingStyle = null,
        cricketRole = null,
        playerStats = null,
        totalTimesOut = null,
        teamsId = null,
        achievements = null,
        matchesPlayed = 0;

  double get battingAverage {
    if (totalTimesOut == 0) {
      return playerStats!.totalRuns.toDouble();
    }

    return playerStats!.totalRuns / totalTimesOut!;
  }

  Map<String, dynamic> get toJsonForPlayer => {
        'playerId': id,
        'email': email,
        'playerName': name,
        'role': role,
        'teamsId': teamsId,
        'matchesPlayed': matchesPlayed,
        'profileImageUrl': profileImageUrl,
        'cricketRole': cricketRole!.name,
        'battingPosition': battingPosition!.name,
        'totalTimesOut': totalTimesOut,
        'bowlingArm': bowlingArm?.name,
        'bowlingStyle': bowlingStyle!.name,
        'createdAt': createdAt,
        'bestBalling': [bestBalling?.runGiven, bestBalling!.ballDelivered],
        'achievements': achievements,
        ...playerStats!.toJson,
      };

  Map<String, dynamic> get toJsonForUser => {
        'userId': id,
        'email': email,
        'username': name,
        'role': role,
        'profileImageUrl': profileImageUrl,
        'createdAt': createdAt,
      };

  static Player fromSeed(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final snap = snapshot.data()!;

    return Player(
      role: snap['role'],
      id: snap['playerId'],
      name: snap['playerName'],
      email: snap['email'],
      profileImageUrl: snap['profileImageUrl'],
      cricketRole: snap['cricketRole'],
      battingPosition: snap['battingPosition'],
      bowlingArm: snap['bowlingArm'],
      bowlingStyle: snap['bowlingStyle'],
      createdAt: snap['createdAt'],
      teamsId: snap['teamsId'],
      bestBalling: BowlingFigure(
        snap['bestBalling'][0],
        snap['bestBalling'][1],
      ),
      playerStats: PlayerStats(
        ballDelivered: snap['ballDelivered'],
        ballsFaced: snap['ballsFaced'],
        fifties: snap['fifties'],
        four: snap['four'],
        highestScore: snap['highestScore'],
        hundreds: snap['hundreds'],
        maiden: snap['maiden'],
        runGiven: snap['runGiven'],
        six: snap['six'],
        totalRuns: snap['totalRuns'],
        wicket: snap['wicket'],
      ),
      matchesPlayed: snap['matchesPlayed'],
      achievements: snap['achievements'],
    );
  }
}
