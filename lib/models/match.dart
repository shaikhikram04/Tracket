import 'package:tracket/models/team.dart';
import 'package:uuid/uuid.dart';

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
  BattingScore({
    required this.uuid,
    required this.playerName,
    this.reasonOfOut,
    this.ballFaced = 0,
    this.fours = 0,
    this.isOut = false,
    this.runs = 0,
    this.sixs = 0,
  });

  final String uuid;
  final String playerName;
  final int runs;
  final int ballFaced;
  final int sixs;
  final int fours;
  final bool isOut;
  final ReasonOfOut? reasonOfOut;

  double get strikeRate {
    if (ballFaced == 0) {
      return 0;
    }

    return (runs / ballFaced) * 100;
  }

  // void getOut(ReasonOfOut outReason) {
  //   isOut = true;
  //   reasonOfOut = outReason;
  // }
}

class BowlingScore {
  BowlingScore({
    required this.uuid,
    required this.playerName,
    this.ball = 0,
    this.maidenOver = 0,
    this.runGiven = 0,
    this.wicket = 0,
  });

  final String uuid;
  final String playerName;
  final int ball;
  final int runGiven;
  final int wicket;
  final int maidenOver;

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
            BattingScore(uuid: player['id'], playerName: player['name']),
        ],
        bowlingStats = [
          for (final player in bowlingTeam.playerList)
            BowlingScore(uuid: player['id'], playerName: player['name']),
        ];

  final Team battingTeam;
  final Team bowlingTeam;
  final List<BattingScore> battingStats;
  final List<BowlingScore> bowlingStats;
  final int runs = 0;
  final double over = 0.0;
  final int wickets = 0;
  final int balls = 0;
  final int wides = 0;
  final int noBalls = 0;
  final int legByes = 0;
  final int byes = 0;
  final int fours = 0;
  final int sixs = 0;
  final bool declared = false;
  final bool allOut = false;

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

  // void declareInning() {
  //   declared = true;
  // }
}

enum TossDecision {
  batting,
  fielding,
}

const uuid = Uuid();

class Match {
  Match({
    required this.team1,
    required this.team2,
    required this.noOfPlayer,
    required this.over,
    required this.isTeam1WonToss,
    required this.tossDecision,
  })  : id = uuid.v4(),
        inning1 = isTeam1WonToss
            ? (tossDecision == TossDecision.batting
                ? Inning(battingTeam: team1, bowlingTeam: team2)
                : Inning(battingTeam: team2, bowlingTeam: team1))
            : (tossDecision == TossDecision.batting
                ? Inning(battingTeam: team2, bowlingTeam: team1)
                : Inning(battingTeam: team1, bowlingTeam: team2)),
        inning2 = isTeam1WonToss
            ? (tossDecision == TossDecision.batting
                ? Inning(battingTeam: team2, bowlingTeam: team1)
                : Inning(battingTeam: team1, bowlingTeam: team2))
            : (tossDecision == TossDecision.batting
                ? Inning(battingTeam: team1, bowlingTeam: team2)
                : Inning(battingTeam: team2, bowlingTeam: team1));

  final String id;
  final Team team1;
  final Team team2;
  final int over;
  final int noOfPlayer;
  final bool isTeam1WonToss;
  final TossDecision tossDecision;

  Inning inning1;
  Inning inning2;
}
