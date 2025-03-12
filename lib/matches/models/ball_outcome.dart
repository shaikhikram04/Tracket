import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/matches/models/batting_score.dart';

/// Defines the types of balls that can be bowled in cricket.
enum BallType {
  valid,
  wide,
  noBall,
  bye,
  legBye,
  // dead
}

/// Represents the outcome of a single ball in a cricket match.
class BallOutcome {
  final String ballId;
  final BallType type;
  final int runs;
  final bool isWicket;
  final ReasonOfOut? reasonOfOut;
  final Timestamp timestamp;
  final int ballNumber;
  final bool isBoundary;

  const BallOutcome({
    required this.type,
    required this.runs,
    required this.ballNumber,
    required this.ballId,
    required this.timestamp,
    required this.isBoundary,
    this.isWicket = false,
    this.reasonOfOut,
  });

  int get remainingBalls => 6 - ballNumber;

  String get displayOutcome {
    if (isWicket) {
      if (reasonOfOut == ReasonOfOut.runOut && runs > 0) {
        return '${runs}W';
      }
      return 'W';
    }

    switch (type) {
      case BallType.valid:
        return '$runs';
      case BallType.wide:
        return runs <= 0 ? 'WD' : '${runs}WD';
      case BallType.noBall:
        return runs == 0 ? 'NB' : '${runs}NB';
      case BallType.bye:
        return '${runs}BY';
      case BallType.legBye:
        return '${runs}LB';
    }
  }

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'runs': runs,
        'isWicket': isWicket,
        'reasonOfOut': reasonOfOut?.name,
        'ballId': ballId,
        'timestamp': timestamp,
        'ballNumber': ballNumber,
        'isBoundary': isBoundary,
      };

  factory BallOutcome.fromMap(Map<String, dynamic> map) {
    return BallOutcome(
      ballId: map['ballId'],
      type: BallType.values.firstWhere(
        (type) => type.name == map['type'],
        orElse: () => BallType.valid,
      ),
      runs: map['runs'],
      isWicket: map['isWicket'] ?? false,
      timestamp: map['timestamp'],
      ballNumber: map['ballNumber'],
      isBoundary: map['isBoundary'],
      reasonOfOut: map['reasonOfOut'] != null
          ? ReasonOfOut.values.firstWhere(
              (reason) => reason.name == map['reasonOfOut'],
              orElse: () => ReasonOfOut.bowled,
            )
          : null,
    );
  }

  static List<BallOutcome> fromQuerySnapshot(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    return docs.map((doc) => BallOutcome.fromMap(doc.data())).toList();
  }
}
