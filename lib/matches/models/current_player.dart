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

  Map<String, dynamic> toMap() => {
        'id': id,
        'playerName': playerName,
        'runs': runs,
        'balls': balls,
      };

  StrikerData addRuns(int runs) {
    return copyWith(runs: this.runs + runs, balls: balls + 1);
  }
  

  StrikerData copyWith({
    int? runs,
    int? balls,
  }) {
    return StrikerData(
      id: id,
      playerName: playerName,
      runs: runs ?? this.runs,
      balls: balls ?? this.balls,
    );
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

  CurrentBowlerData addBall({
    required int runs,
    required bool isWicket,
    required bool isWide,
    required bool isNoBall,
  }) {
    final runsGiven =
        this.runsGiven + (isWide || isNoBall ? 1 : 0) + (!isWide ? runs : 0);
    final balls = this.balls + (isWide || isNoBall ? 0 : 1);
    final wickets = isWicket ? this.wickets + 1 : this.wickets;

    return copyWith(
      runsGiven: runsGiven,
      balls: balls,
      wickets: wickets,
    );
  }

  CurrentBowlerData copyWith({
    int? runsGiven,
    int? wickets,
    int? balls,
  }) {
    return CurrentBowlerData(
        playerName: playerName,
        id: id,
        runsGiven: runsGiven ?? this.runsGiven,
        wickets: wickets ?? this.wickets,
        balls: balls ?? this.balls);
  }
}
