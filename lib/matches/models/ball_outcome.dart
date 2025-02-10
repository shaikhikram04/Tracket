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

  const BallOutcome({
    required this.type,
    required this.runs,
    this.isWicket = false,
  });

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'runs': runs,
        'isWicket': isWicket,
      };

  String get displayOutcome {
    switch (type) {
      case BallType.valid:
        return '$runs';
      case BallType.wide:
        return '${runs}WD';
      case BallType.noBall:
        return '${runs}NB';
      case BallType.bye:
        return '${runs}BY';
      case BallType.legBye:
        return '${runs}LB';
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
