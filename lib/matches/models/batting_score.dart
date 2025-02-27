enum ReasonOfOut {
  bowled('Bowled'),
  lbw('LBW'),
  stumped('Stumped'),
  hitWicket('Hit Wicket'),
  // retiredOut('Retired Out'),
  caught('Caught'),
  runOut('Run Out'),
  ;

  const ReasonOfOut(this.description);
  final String description;
}

class BattingScore {
  BattingScore({
    required this.uuid,
    required this.playerName,
    this.reasonOfOut,
    this.ballsFaced,
    this.fours,
    this.isOut = false,
    this.runs,
    this.sixes,
    this.dismissalInfo = '',
  });

  final String uuid;
  final String playerName;
  final int? runs;
  final int? ballsFaced;
  final int? sixes;
  final int? fours;
  final bool isOut;
  final ReasonOfOut? reasonOfOut;
  final String dismissalInfo;

  double? get strikeRate {
    if (runs == null || ballsFaced == null) return null;

    if (ballsFaced == 0) return 0.0;

    return (runs! / ballsFaced!) * 100;
  }

  // Additional useful methods
  int? get totalBoundaries =>
      (fours == null || sixes == null) ? null : fours! + sixes!;

  int? get runsFromBoundaries =>
      (fours == null || sixes == null) ? null : (fours! * 4) + (sixes! * 6);

  double? get boundaryPercentage {
    if (runs == null || runsFromBoundaries == null) return null;
    if (runs == 0) return 0.0;
    return (runsFromBoundaries! / runs!) * 100;
  }

  // Immutable state updates
  BattingScore markAsOut(ReasonOfOut outReason) {
    return copyWith(
      isOut: true,
      reasonOfOut: outReason,
    );
  }

  BattingScore addRuns(int runs, {required bool isSix, required bool isFour}) {
    if (this.runs == null || this.ballsFaced == null) return this;

    return copyWith(
      runs: this.runs! + runs,
      ballsFaced: ballsFaced! + 1,
      fours: isFour ? (fours ?? 0) + 1 : fours,
      sixes: isSix ? (sixes ?? 0) + 1 : sixes,
    );
  }

  BattingScore wicket(int runs, bool isAddBall) {
    if (this.runs == null || this.ballsFaced == null) return this;
    return copyWith(
      isOut: true,
      ballsFaced: isAddBall ? ballsFaced! + 1 : ballsFaced,
      runs: this.runs! + runs,
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
    };
  }

  static BattingScore fromMap(Map<String, dynamic> map) {
    return BattingScore(
      uuid: map['uuid'],
      playerName: map['playerName'],
      runs: map['runs'],
      ballsFaced: map['ballsFaced'],
      fours: map['fours'],
      sixes: map['sixes'],
      isOut: map['isOut'],
      reasonOfOut: map['reasonOfOut'] != null
          ? ReasonOfOut.values.firstWhere((e) => e.name == map['reasonOfOut'])
          : null,
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
      );
}
