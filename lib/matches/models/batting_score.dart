enum ReasonOfOut {
  bowled,
  lbw,
  caught,
  runOut,
  stumped,
  hitWicket,
  retiredOut,
}

extension ReasonOfOutDescription on ReasonOfOut {
  String get description {
    switch (this) {
      case ReasonOfOut.bowled:
        return 'Bowled';
      case ReasonOfOut.lbw:
        return 'LBW';
      case ReasonOfOut.caught:
        return 'Caught';
      case ReasonOfOut.runOut:
        return 'Run Out';
      case ReasonOfOut.stumped:
        return 'Stumped';
      case ReasonOfOut.hitWicket:
        return 'Hit Wicket';
      case ReasonOfOut.retiredOut:
        return 'Retired Out';
    }
  }
}

class BattingScore {
  BattingScore({
    required this.uuid,
    required this.playerName,
    this.reasonOfOut,
    this.ballFaced = 0,
    this.fours = 0,
    this.isOut = false,
    this.runs = 0,
    this.sixs = 0,
  });

  final String uuid;
  final String playerName;
  final int runs;
  final int ballFaced;
  final int sixs;
  final int fours;
  bool isOut;
  ReasonOfOut? reasonOfOut;

  double get strikeRate {
    if (ballFaced == 0) {
      return 0;
    }

    return (runs / ballFaced) * 100;
  }

  void getOut(ReasonOfOut outReason) {
    isOut = true;
    reasonOfOut = outReason;
  }
}
