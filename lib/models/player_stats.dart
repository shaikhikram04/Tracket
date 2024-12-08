class PlayerStats {
  PlayerStats({
    this.totalRuns = 0,
    this.ballsFaced = 0,
    this.highestScore = 0,
    this.hundreds = 0,
    this.fifties = 0,
    this.four = 0,
    this.six = 0,
    this.wicket = 0,
    this.runGiven = 0,
    this.ballDelivered = 0,
    this.maiden = 0,
  }) : userId = null;

  PlayerStats.matchStats({
    required this.userId,
    this.totalRuns = 0,
    this.ballsFaced = 0,
    this.highestScore = 0,
    this.hundreds = 0,
    this.fifties = 0,
    this.four = 0,
    this.six = 0,
    this.wicket = 0,
    this.runGiven = 0,
    this.ballDelivered = 0,
    this.maiden = 0,
  });

  //* Identifing user uniquely
  final String? userId;

  //* Batting stats
  final int totalRuns;
  final int ballsFaced;
  final int highestScore;
  final int hundreds;
  final int fifties;
  final int four;
  final int six;

  //* Bowling stats
  final int wicket;
  final int runGiven;
  final int ballDelivered;
  final int maiden;

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

    return runGiven / wicket;
  }

  double get economyRate {
    if (ballDelivered == 0) {
      return 0;
    }

    return runGiven / ballDelivered;
  }

  Map<String, dynamic> get toJson => {
        'totalRuns': totalRuns,
        'ballsFaced': ballsFaced,
        'highestScore': highestScore,
        'hundreds': hundreds,
        'fifties': fifties,
        'four': four,
        'six': six,
        'wicket': wicket,
        'runGiven': runGiven,
        'ballDelivered': ballDelivered,
        'maiden': maiden,
      };
}
