import 'package:tracket/players/models/bowling_figure.dart';

class BowlingStats {
  final int wicket;
  final int runGiven;
  final int ballDelivered;
  final BowlingFigure? bestBallingFigure;
  final int maiden;

  const BowlingStats({
    this.wicket = 0,
    this.runGiven = 0,
    this.ballDelivered = 0,
    this.maiden = 0,
    this.bestBallingFigure = const BowlingFigure(
      runGiven: 0,
      ballDelivered: 0,
      wicket: 0,
    ),
  });

  const BowlingStats.matchStats({
    this.wicket = 0,
    this.runGiven = 0,
    this.ballDelivered = 0,
    this.maiden = 0,
  }) : bestBallingFigure = null;

  double get bowlingAverage {
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
        'wicket': wicket,
        'runGiven': runGiven,
        'ballDelivered': ballDelivered,
        'maiden': maiden,
        'bestBallingFigure': bestBallingFigure?.toJson,
      };

  static BowlingStats fromMap(Map<String, dynamic> snap) {
    return BowlingStats(
      ballDelivered: snap['ballDelivered'],
      bestBallingFigure: BowlingFigure.fromMap(snap['bestBallingFigure']),
      maiden: snap['maiden'],
      runGiven: snap['runGiven'],
      wicket: snap['wicket'],
    );
  }
}
