import 'package:tracket/models/team.dart';

class Inning {
  Inning({
    required this.runs,
    required this.over,
    required this.wickets,
    required this.wides,
    required this.noBalls,
    required this.legByes,
    required this.byes,
    required this.sixs,
    required this.fours,
    required this.balls,
  });

  int runs;
  double over;
  int wickets;
  int balls;
  int wides;
  int noBalls;
  int legByes;
  int byes;
  int fours;
  int sixs;
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
