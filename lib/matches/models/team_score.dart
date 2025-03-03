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

  Map<String, dynamic> toMap() => {
    'runs' : runs,
    'balls' : balls,
    'wickets' : wickets,
  };
}
