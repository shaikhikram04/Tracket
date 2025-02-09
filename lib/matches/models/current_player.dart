class StrikerData {
  final int runs;
  final int balls;
  final String playerName;
  final String id;

  StrikerData({
    required this.id,
    required this.playerName,
    required this.runs,
    required this.balls,
  });

  double get strikeRate {
    if (balls == 0) return 0.0;

    return (runs / balls) * 100;
  }
}

class CurrentBowlerData {
  final String playerName;
  final String id;
  final int runsGiven;
  final int wickets;
  final int balls;

  CurrentBowlerData({
    required this.playerName,
    required this.id,
    required this.runsGiven,
    required this.wickets,
    required this.balls,
  });

  // Computed properties
  int get completedOvers => balls ~/ 6;
  int get remainingBalls => balls % 6;

  String get oversDisplay => '$completedOvers.${remainingBalls}';

  double get economy {
    if (balls == 0) {
      return 0;
    }

    return runsGiven / (balls / 6.0);
  }
}
