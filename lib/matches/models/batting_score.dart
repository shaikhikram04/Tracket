enum ReasonOfOut {
  bowled('Bowled'),
  lbw('LBW'),
  stumped('Stumped'),
  hitWicket('Hit Wicket'),
  caught('Caught'),
  runOut('Run Out');

  const ReasonOfOut(this.description);
  final String description;
}

class BattingScore {
  final String uuid;
  final String playerName;
  final int runs;
  final int ballsFaced;
  final int sixes;
  final int fours;
  final bool isOut;
  final ReasonOfOut? reasonOfOut;
  final String dismissalInfo;
  final int battingPosition;

  BattingScore({
    required this.uuid,
    required this.playerName,
    required this.battingPosition,
    this.reasonOfOut,
    this.ballsFaced = 0,
    this.fours = 0,
    this.isOut = false,
    this.runs = 0,
    this.sixes = 0,
    this.dismissalInfo = '',
  });

  double get strikeRate {
    if (ballsFaced == 0) return 0.0;

    return (runs / ballsFaced) * 100;
  }

  // Additional useful methods
  int get totalBoundaries => fours + sixes;

  int get runsFromBoundaries => (fours * 4) + (sixes * 6);

  double get boundaryPercentage {
    if (runs == 0) return 0.0;
    return (runsFromBoundaries / runs) * 100;
  }

  String get displayScore {
    final notOutIndicator = isOut ? '' : '*';
    return '$runs$notOutIndicator ($ballsFaced)';
  }

  BattingScore addRuns(int runs, {required bool isSix, required bool isFour}) {
    return copyWith(
      runs: this.runs + runs,
      ballsFaced: ballsFaced + 1,
      fours: isFour ? fours + 1 : fours,
      sixes: isSix ? sixes + 1 : sixes,
    );
  }

  BattingScore wicket(int runs, {required bool countBall, required ReasonOfOut reasonOfOut, String? dismissalInfo}) {
    return copyWith(
      isOut: true,
      ballsFaced: countBall ? ballsFaced + 1 : ballsFaced,
      runs: this.runs + runs,
      reasonOfOut: reasonOfOut,
      dismissalInfo: dismissalInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'playerName': playerName,
      'runs': runs,
      'ballsFaced': ballsFaced,
      'fours': fours,
      'sixes': sixes,
      'isOut': isOut,
      'reasonOfOut': reasonOfOut?.name,
      'dismissalInfo': dismissalInfo,
      'battingPosition': battingPosition,
    };
  }

  static BattingScore fromMap(Map<String, dynamic> map) {
    return BattingScore(
      uuid: map['uuid'] ?? '',
      playerName: map['playerName'] ?? '',
      runs: map['runs'] ?? 0,
      ballsFaced: map['ballsFaced'] ?? 0,
      fours: map['fours'] ?? 0,
      sixes: map['sixes'] ?? 0,
      isOut: map['isOut'] ?? false,
      reasonOfOut: map['reasonOfOut'] != null
          ? ReasonOfOut.values.firstWhere(
              (e) => e.name == map['reasonOfOut'],
              orElse: () => ReasonOfOut.bowled,
            )
          : null,
      battingPosition: map['battingPosition'] ?? 0,
      dismissalInfo: map['dismissalInfo'] ?? '',
    );
  }

  BattingScore copyWith({
    bool? isOut,
    ReasonOfOut? reasonOfOut,
    String? playerName,
    int? ballsFaced,
    int? fours,
    int? runs,
    int? sixes,
    int? battingPosition,
    String? dismissalInfo,
  }) =>
      BattingScore(
        uuid: uuid,
        playerName: playerName ?? this.playerName,
        ballsFaced: ballsFaced ?? this.ballsFaced,
        fours: fours ?? this.fours,
        isOut: isOut ?? this.isOut,
        reasonOfOut: reasonOfOut ?? reasonOfOut,
        runs: runs ?? this.runs,
        sixes: sixes ?? this.sixes,
        battingPosition: battingPosition ?? this.battingPosition,
        dismissalInfo: dismissalInfo ?? this.dismissalInfo,
      );
}
