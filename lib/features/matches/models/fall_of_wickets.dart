class FallOfWicket {
  final int wicketNumber;
  final int runsAtFall;
  final String batsmanName;
  final int balls;

  const FallOfWicket({
    required this.wicketNumber,
    required this.runsAtFall,
    required this.batsmanName,
    required this.balls,
  });

  int get overNumber => balls ~/ 6;

  int get ballInOver => balls % 6;

  String get oversDisplay {
    return '$overNumber.$ballInOver';
  }

  /// Returns a formatted display of the fall of wicket (e.g., "1-42 (Smith, 5.2 ov)").
  String get display {
    return "$wicketNumber-$runsAtFall ($batsmanName, $oversDisplay ov)";
  }

  Map<String, dynamic> toMap() {
    return {
      'wicketNumber': wicketNumber,
      'runsAtFall': runsAtFall,
      'batsmanName': batsmanName,
      'balls': balls,
    };
  }

  static FallOfWicket fromMap(Map<String, dynamic> map) {
    return FallOfWicket(
      wicketNumber: map['wicketNumber'] ?? 0,
      runsAtFall: map['runsAtFall'] ?? 0,
      batsmanName: map['batsmanName'] ?? '',
      balls: map['balls'] ?? 0,
    );
  }

  FallOfWicket copyWith({
    int? wicketNumber,
    int? runsAtFall,
    String? batsmanName,
    int? balls,
  }) {
    return FallOfWicket(
      wicketNumber: wicketNumber ?? this.wicketNumber,
      runsAtFall: runsAtFall ?? this.runsAtFall,
      batsmanName: batsmanName ?? this.batsmanName,
      balls: balls ?? this.balls,
    );
  }

  /// Returns the partnership for this wicket (based on previous wicket details if provided).
  static int calculatePartnership(
      FallOfWicket current, FallOfWicket? previous) {
    if (previous == null) {
      // If it's the first wicket, partnership is the total runs
      return current.runsAtFall;
    }
    // Otherwise, partnership is the difference between this and previous wicket
    return current.runsAtFall - previous.runsAtFall;
  }

  /// Returns the balls faced in the partnership.
  static int calculatePartnershipBalls(
      FallOfWicket current, FallOfWicket? previous) {
    if (previous == null) {
      // If it's the first wicket, balls faced is the total balls
      return current.balls;
    }
    // Otherwise, balls faced is the difference between this and previous wicket
    return current.balls - previous.balls;
  }

  /// Returns a formatted list of fall of wickets for scorecard display.
  static String formatWicketsList(List<FallOfWicket> wickets) {
    return wickets.map((w) => w.display).join(" • ");
  }

  /// Returns the average runs per ball for the partnership.
  static double partnershipRunRate(
      FallOfWicket current, FallOfWicket? previous) {
    final partnership = calculatePartnership(current, previous);
    final balls = calculatePartnershipBalls(current, previous);

    if (balls == 0) return 0.0;
    return (partnership * 6) / balls;
  }
}
