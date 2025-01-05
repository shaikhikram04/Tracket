class BowlingScore {
  BowlingScore({
    required this.uuid,
    required this.playerName,
    this.balls = 0,
    this.maidenOver = 0,
    this.runGiven = 0,
    this.wicket = 0,
  });

  final String uuid;
  final String playerName;
  final int balls;
  final int runGiven;
  final int wicket;
  final int maidenOver;

  double get economy {
    if (balls == 0) {
      return 0;
    }

    return runGiven / (balls / 6.0);
  }
}
