class BowlingFigure {
  final int runGiven;
  final int ballDelivered;
  final int wicket;
  const BowlingFigure({
    required this.runGiven,
    required this.ballDelivered,
    required this.wicket,
  });

  Map<String, dynamic> get toJson => {
        'runGiven': runGiven,
        'ballDelivered': ballDelivered,
        'wicket': wicket,
      };

  static BowlingFigure fromMap(Map<String, dynamic> snap) {
    return BowlingFigure(
      runGiven: snap['runGiven'],
      ballDelivered: snap['ballDelivered'],
      wicket: snap['wicket'],
    );
  }

  String get over {
    final over = ballDelivered ~/ 6;
    final ball = ballDelivered % 6;

    if (ball == 0) {
      return '$over';
    }
    return '$over.$ball';
  }

  String get inString {
    if (over == '0') {
      return '-';
    }
    return '$runGiven / $wicket ($over)';
  }
}
