class Extras {
  const Extras({
    this.wides = 0,
    this.noBalls = 0,
    this.byes = 0,
    this.legByes = 0,
  });
  final int wides;
  final int noBalls;
  final int byes;
  final int legByes;

  int get total => wides + noBalls + byes + legByes;
  int get penaltyRuns => wides + noBalls;

  Map<String, dynamic> toMap() {
    return {
      'wides': wides,
      'noBalls': noBalls,
      'byes': byes,
      'legByes': legByes,
    };
  }

  Extras addExtras({
    required bool isWide,
    required bool isNoBall,
    required bool isBye,
    required bool isLegBye,
  }) {
    return Extras(
      byes: byes + (isBye ? 1 : 0),
      legByes: legByes + (isLegBye ? 1 : 0),
      noBalls: noBalls + (isNoBall ? 1 : 0),
      wides: wides + (isWide ? 1 : 0),
    );
  }

  static Extras fromMap(Map<String, dynamic> map) {
    return Extras(
      wides: map['wides'],
      noBalls: map['noBalls'],
      byes: map['byes'],
      legByes: map['legByes'],
    );
  }

  Extras copyWith({
    int? wides,
    int? noBalls,
    int? byes,
    int? legByes,
  }) =>
      Extras(
        byes: byes ?? this.byes,
        legByes: legByes ?? this.legByes,
        noBalls: noBalls ?? this.noBalls,
        wides: wides ?? this.wides,
      );
}
