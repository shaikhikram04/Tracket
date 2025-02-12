import 'package:tracket/matches/models/batting_score.dart';

enum BallType {
  valid,
  wide,
  noBall,
  bye,
  legBye,
  // dead
}

class BallOutcome {
  final BallType type;
  final int runs;
  final bool isWicket;
  final ReasonOfOut? reasonOfOut;

  const BallOutcome({
    required this.type,
    required this.runs,
    this.isWicket = false,
    this.reasonOfOut,
  });

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'runs': runs,
        'isWicket': isWicket,
      };

  String get displayOutcome {
    if (isWicket) {
      if (reasonOfOut == ReasonOfOut.runOut) {
        String displayRuns = runs == 0 ? '' : runs.toString();
        return '${displayRuns}W';
      }
      return 'W';
    }

    switch (type) {
      case BallType.valid:
        return '$runs';
      case BallType.wide:
        return '${runs == 0 ? '' : runs}WD';
      case BallType.noBall:
        return '${runs == 0 ? '' : runs}NB';
      case BallType.bye:
        return '${runs == 0 ? '' : runs}BY';
      case BallType.legBye:
        return '${runs == 0 ? '' : runs}LB';
    }
  }

  factory BallOutcome.fromMap(Map<String, dynamic> map) {
    return BallOutcome(
      type: BallType.values.firstWhere((type) => type.name == map['type']),
      runs: map['runs'],
      isWicket: map['isWicket'] ?? false,
    );
  }
}
