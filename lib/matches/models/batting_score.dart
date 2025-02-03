enum ReasonOfOut {
  bowled('Bowled'),
  lbw('LBW'),
  caught('Caught'),
  runOut('Run Out'),
  stumped('Stumped'),
  hitWicket('Hit Wicket'),
  retiredOut('Retired Out');

  const ReasonOfOut(this.description);
  final String description;
}

class BattingScore {
  BattingScore({
    required this.uuid,
    required this.playerName,
    this.reasonOfOut,
    this.ballsFaced = 0,
    this.fours = 0,
    this.isOut = false,
    this.runs = 0,
    this.sixes = 0,
  });

  final String uuid;
  final String playerName;
  final int? runs;
  final int? ballsFaced;
  final int? sixes;
  final int? fours;
  bool isOut;
  ReasonOfOut? reasonOfOut;

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

  void getOut(ReasonOfOut outReason) {
    isOut = true;
    reasonOfOut = outReason;
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
