class BowlingScore {
  final String uuid;
  final String playerName;
  final int balls;
  final int runsGiven;
  final int wickets;
  final int maidenOvers;
  final int dots;
  final int wides;
  final int noBalls;

  BowlingScore({
    required this.uuid,
    required this.playerName,
    this.balls = 0,
    this.maidenOvers = 0,
    this.runsGiven = 0,
    this.wickets = 0,
    this.dots = 0,
    this.noBalls = 0,
    this.wides = 0,
  });

  // Computed properties
  int get overs => balls ~/ 6;
  int get remainingBalls => balls % 6;

  String get oversDisplay =>
      remainingBalls == 0 ? overs.toString() : '$overs.${remainingBalls}';

  double get economy {
    if (balls == 0) return 0;

    return (runsGiven * 6) / balls;
  }

  double get average {
    if (wickets == 0) return runsGiven.toDouble();
    return runsGiven / wickets;
  }

  double get maidenPercentage {
    if (overs == 0) return 0.0;
    return (maidenOvers / overs) * 100;
  }

  // Extra runs calculation
  int get extraRuns => wides + noBalls;

  // Dot ball percentage
  double get dotBallPercentage {
    if (balls == 0) return 0.0;
    return (dots / balls) * 100;
  }

  String get bowlingFigures => '$wickets/$runsGiven';

  String get detailedFigures => '$oversDisplay-$wickets-$runsGiven';

  bool get isValidOver => balls % 6 == 0;

  bool get hasValidFigures {
    return balls >= 0 &&
        runsGiven >= 0 &&
        wickets >= 0 &&
        maidenOvers >= 0 &&
        maidenOvers <= overs;
  }

  // Methods to update bowling figures
  BowlingScore addBall({
    required int runs,
    bool isWide = false,
    bool isNoBall = false,
    bool isWicket = false,
  }) {
    return copyWith(
      balls: isWide || isNoBall ? balls : balls + 1,
      runsGiven: runs,
      wides: isWide ? wides + 1 : wides,
      noBalls: isNoBall ? noBalls + 1 : noBalls,
      dots: (runs == 0 && !isWide && !isNoBall && !isWicket) ? dots + 1 : dots,
      wickets: isWicket ? wickets + 1 : wickets,
    );
  }

  BowlingScore addMaidenOver() {
    if (!isValidOver) {
      throw ArgumentError('Cannot add maiden over: current over is incomplete');
    }
    return copyWith(
      maidenOvers: maidenOvers + 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'playerName': playerName,
      'balls': balls,
      'runsGiven': runsGiven,
      'wickets': wickets,
      'maidenOvers': maidenOvers,
      'dots': dots,
      'noBalls': noBalls,
      'wides': wides,
    };
  }

  static BowlingScore fromMap(Map<String, dynamic> map) {
    return BowlingScore(
      uuid: map['uuid'] ?? '',
      playerName: map['playerName'] ?? '',
      balls: map['balls'] ?? 0,
      runsGiven: map['runsGiven'] ?? 0,
      wickets: map['wickets'] ?? 0,
      maidenOvers: map['maidenOvers'] ?? 0,
      dots: map['dots'] ?? 0,
      noBalls: map['noBalls'] ?? 0,
      wides: map['wides'] ?? 0,
    );
  }

  BowlingScore copyWith({
    String? playerName,
    int? balls,
    int? dots,
    int? maidenOvers,
    int? noBalls,
    int? runsGiven,
    int? wickets,
    int? wides,
  }) =>
      BowlingScore(
        uuid: uuid,
        playerName: playerName ?? this.playerName,
        balls: balls ?? this.balls,
        dots: dots ?? this.dots,
        maidenOvers: maidenOvers ?? this.maidenOvers,
        noBalls: noBalls ?? this.noBalls,
        runsGiven: runsGiven ?? this.runsGiven,
        wickets: wickets ?? this.wickets,
        wides: wides ?? this.wides,
      );
}
