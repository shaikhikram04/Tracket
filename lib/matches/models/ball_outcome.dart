enum BallType {
  valid,
  wide,
  noBall,
  bye,
  legBye,
  dead
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

  factory BallOutcome.fromMap(Map<String, dynamic> map) {
    return BallOutcome(
      type: BallType.values.firstWhere((type) => type.name == map['type']),
      runs: map['runs'],
      isWicket: map['isWicket'] ?? false,
    );
  }
}