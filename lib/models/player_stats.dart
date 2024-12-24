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

class PlayerStats {
  PlayerStats({
    this.totalRuns = 0,
    this.ballsFaced = 0,
    this.highestScore = 0,
    this.hundreds = 0,
    this.fifties = 0,
    this.four = 0,
    this.six = 0,
    this.wicket = 0,
    this.runGiven = 0,
    this.ballDelivered = 0,
    this.maiden = 0,
    this.innings = 0,
    this.matches = 0,
    this.bestBallingFigure = const BowlingFigure(
      runGiven: 0,
      ballDelivered: 0,
      wicket: 0,
    ),
    this.outCount = 0,
  }) : userId = null;

  PlayerStats.matchStats({
    required this.userId,
    this.totalRuns = 0,
    this.ballsFaced = 0,
    this.four = 0,
    this.six = 0,
    this.wicket = 0,
    this.runGiven = 0,
    this.ballDelivered = 0,
    this.maiden = 0,
  })  : matches = null,
        innings = null,
        highestScore = null,
        hundreds = null,
        fifties = null,
        bestBallingFigure = null,
        outCount = null;

  //* Identifing user uniquely
  final String? userId;

  final int? matches;

  //* Batting stats
  final int? innings;
  final int totalRuns;
  final int ballsFaced;
  final int? highestScore;
  final int? hundreds;
  final int? fifties;
  final int four;
  final int six;
  final int? outCount;

  //* Bowling stats
  final int wicket;
  final int runGiven;
  final int ballDelivered;
  final BowlingFigure? bestBallingFigure;
  final int maiden;

  double get strikeRate {
    if (ballsFaced == 0) {
      return 0;
    }
    return (totalRuns / ballsFaced) * 100;
  }

  double get battingAverage {
    if (outCount == 0) {
      return totalRuns.toDouble();
    }

    return totalRuns / outCount!;
  }

  double get bowingAverage {
    if (wicket == 0) {
      return 0;
    }

    return runGiven / wicket;
  }

  double get economyRate {
    if (ballDelivered == 0) {
      return 0;
    }

    return runGiven / ballDelivered;
  }

  Map<String, dynamic> get toJson => {
        'totalRuns': totalRuns,
        'ballsFaced': ballsFaced,
        'highestScore': highestScore,
        'hundreds': hundreds,
        'fifties': fifties,
        'four': four,
        'six': six,
        'wicket': wicket,
        'runGiven': runGiven,
        'ballDelivered': ballDelivered,
        'maiden': maiden,
        'innings': innings,
        'matches': matches,
        'bestBallingFigure': bestBallingFigure?.toJson,
        'outCount': outCount,
      };
}
