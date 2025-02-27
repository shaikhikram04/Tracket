import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String ballId;
  final BallType type;
  final int runs;
  final bool isWicket;
  final ReasonOfOut? reasonOfOut;
  final Timestamp timestamp;
  final int ballNumber;

  const BallOutcome({
    required this.type,
    required this.runs,
    required this.ballNumber,
    required this.ballId,
    required this.timestamp,
    this.isWicket = false,
    this.reasonOfOut,
  });

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'runs': runs,
        'isWicket': isWicket,
        'reasonOfOut': reasonOfOut?.name,
        'ballId': ballId,
        'timestamp': timestamp,
        'ballNumber': ballNumber,
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
      ballId: map['ballId'],
      timestamp: map['timestamp'],
      ballNumber: map['ballNumber'],
      reasonOfOut: map['reasonOfOut'] != null
          ? ReasonOfOut.values.firstWhere(
              (reason) => reason.name == map['reasonOfOut'],
              orElse: () => ReasonOfOut.bowled,
            )
          : null,
    );
  }
}
