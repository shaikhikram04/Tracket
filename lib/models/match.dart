import 'package:tracket/teams/models/team.dart';
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

extension ReasonOfOutDescription on ReasonOfOut {
  String get description {
    switch (this) {
      case ReasonOfOut.bowled: return 'Bowled';
      case ReasonOfOut.lbw: return 'LBW';
      case ReasonOfOut.caught: return 'Caught';
      case ReasonOfOut.runOut: return 'Run Out';
      case ReasonOfOut.stumped: return 'Stumped';
      case ReasonOfOut.hitWicket: return 'Hit Wicket';
      case ReasonOfOut.retiredOut: return 'Retired Out';
    }
  }
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
  bool isOut;
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
  BowlingScore({
    required this.uuid,
    required this.playerName,
    this.balls = 0,
    this.maidenOver = 0,
    this.runGiven = 0,
    this.wicket = 0,
  });

  final String uuid;
  final String playerName;
  final int balls;
  final int runGiven;
  final int wicket;
  final int maidenOver;

  double get economy {
    if (balls == 0) {
      return 0;
    }

    return runGiven / (balls / 6.0);
  }
}

List<T> initializeStats<T>(List players, T Function(dynamic) builder) {
  return players.map(builder).toList();
}

class Inning {
  Inning({
    required this.battingTeam,
    required this.bowlingTeam,
  })  : battingStats = initializeStats(
          battingTeam.playersList,
          (player) =>
              BattingScore(uuid: player['id'], playerName: player['name']),
        ),
        bowlingStats = initializeStats(
          bowlingTeam.playersList,
          (player) =>
              BowlingScore(uuid: player['id'], playerName: player['name']),
        );

  final Team battingTeam;
  final Team bowlingTeam;
  final List<BattingScore> battingStats;
  final List<BowlingScore> bowlingStats;
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
  bool declared = false;
  bool allOut = false;

  double get computedOvers => balls ~/ 6 + (balls % 6) / 10;

  double get runRate {
    if (computedOvers == 0) {
      return 0.0;
    }
    return (runs / computedOvers).toDouble();
  }

  void addRuns(int run, {bool isFour = false, bool isSix = false}) {
    runs += run;
    balls++;
    if (isFour) fours++;
    if (isSix) sixs++;
  }

  int get totalExtras {
    return wides + noBalls + legByes + byes;
  }

  void declareInning() {
    declared = true;
  }

  void onAllOut() {
    allOut = true;
  }

  void addExtras({
    int wides = 0,
    int noBalls = 0,
    int byes = 0,
    int legByes = 0,
  }) {
    this.wides += wides;
    this.noBalls += noBalls;
    this.byes += byes;
    this.legByes += legByes;
  }
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
