class TeamScore {
  final runs;
  final balls;
  final wickets;

  TeamScore({
    required this.runs,
    required this.balls,
    required this.wickets,
  });

  // Computed properties
  int get completedOvers => balls ~/ 6;
  int get remainingBalls => balls % 6;

  String get oversDisplay => '$completedOvers.${remainingBalls}';

  TeamScore addDelevery({
    required int runs,
    required bool isAddBall,
    required bool isWicket,
  }) {
    return TeamScore(
      runs: this.runs + runs,
      balls: this.balls + (isAddBall ? 1 : 0),
      wickets: this.wickets + (isWicket ? 1 : 0),
    );
  }

  Map<String, dynamic> toMap() => {
        'runs': runs,
        'balls': balls,
        'wickets': wickets,
      };

  static TeamScore? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return TeamScore(
      balls: map['balls'],
      runs: map['runs'],
      wickets: map['wickets'],
    );
  }
}
