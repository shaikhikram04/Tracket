import 'package:tracket/models/team.dart';

enum ReasonOfOut {
  bowled,
  lbw,
  caught,
  runOut,
  stumped,
  hitWicket,
  retiredOut,
}

class BattingScore {
  BattingScore(this.uuid, this.name);

  String uuid;
  String name;
  int runs = 0;
  int ballFaced = 0;
  int sixs = 0;
  int fours = 0;
  bool isOut = false;
  ReasonOfOut? reasonOfOut;

  double get strikeRate {
    if (ballFaced == 0) {
      return 0;
    }

    return (runs / ballFaced) * 100;
  }

  void getOut(ReasonOfOut outReason) {
    isOut = true;
    reasonOfOut = outReason;
  }
}

class BowlingScore {
  BowlingScore(this.uuid, this.name);

  String uuid;
  String name;
  int ball = 0;
  int runGiven = 0;
  int wicket = 0;
  int maidenOver = 0;

  double get economy {
    if (ball == 0) {
      return 0;
    }

    return runGiven / (ball / 6.0);
  }
}

class Inning {
  Inning({
    required this.battingTeam,
    required this.bowlingTeam,
  })  : battingStats = [
          for (final player in battingTeam.playerList)
            BattingScore(player.id, player.name),
        ],
        bowlingStats = [
          for (final player in bowlingTeam.playerList)
            BowlingScore(player.id, player.name),
        ];

  Team battingTeam;
  Team bowlingTeam;
  int runs = 0;
  double over = 0.0;
  int wickets = 0;
  int balls = 0;
  int wides = 0;
  int noBalls = 0;
  int legByes = 0;
  int byes = 0;
  int fours = 0;
  int sixs = 0;
  List<BattingScore> battingStats;
  List<BowlingScore> bowlingStats;
  bool declared = false;
  bool allOut = false;

  double get runRate {
    if (over == 0) {
      return 0.0;
    }
    var longRunRate = (runs / balls * 6).toStringAsFixed(2);
    return double.parse(longRunRate);
  }

  int get totalExtras {
    return wides + noBalls + legByes + byes;
  }

  void declareInning() {
    declared = true;
  }
}

class Match {
  Match(
    this.team1,
    this.team2,
    this.noOfPlayer,
    this.over,
    this.inning1,
    this.inning2,
  );

  Team team1;
  Team team2;
  int over;
  int noOfPlayer;
  Inning inning1;
  Inning inning2;
}
