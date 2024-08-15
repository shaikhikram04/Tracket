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

class Player {
  Player({
    required this.name,
    required this.age,
    required this.role,
    required this.battingPosition,
  });

  Player.bowler({
    required this.name,
    required this.age,
    required this.role,
    required this.battingPosition,
    required this.bowingArm,
    required this.bowlingStyle,
  })  : wicket = 0,
        runGiven = 0,
        ballDelivered = 0,
        maiden = 0,
        bestBalling = 0;

  final String name;
  int age;
  CricketRole role;
  Position battingPosition;
  int matchesPlayed = 0;
  int totalRuns = 0;
  int ballsFaced = 0;
  int highestScore = 0;
  int totalTimesOut = 0;
  int hundreds = 0;
  int fifties = 0;
  int four = 0;
  int six = 0;
  int? wicket;
  int? runGiven;
  int? ballDelivered;
  int? maiden;
  int? bestBalling;
  Position? bowingArm;
  BowingStyle? bowlingStyle;

  double get battingAverage {
    if (totalTimesOut == 0) {
      return totalRuns.toDouble();
    }

    return totalRuns / totalTimesOut;
  }

  double get strikeRate {
    if (ballsFaced == 0) {
      return 0;
    }
    return (totalRuns / ballsFaced) * 100;
  }

  double get bowingAverage {
    if (wicket == 0) {
      return 0;
    }

    return runGiven! / wicket!;
  }

  double get economyRate {
    if (ballDelivered == 0) {
      return 0;
    }

    return runGiven! / ballDelivered!;
  }
}
