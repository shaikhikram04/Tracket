import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/match_team_info.dart';

List<T> initializeStats<T>(List players, T Function(dynamic) builder) {
  return players.map(builder).toList();
}

class Inning {
  Inning({
    required this.battingTeam,
    required this.bowlingTeam,
    required this.battingStats,
    required this.bowlingStats,
  });

  final MatchTeamInfo battingTeam;
  final MatchTeamInfo bowlingTeam;
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
