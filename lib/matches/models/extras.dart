class Extras {
  final int wides;
  final int noBalls;
  final int byes;
  final int legByes;

  const Extras({
    this.wides = 0,
    this.noBalls = 0,
    this.byes = 0,
    this.legByes = 0,
  });

  int get total => wides + noBalls + byes + legByes;

  int get penaltyRuns => wides + noBalls;

  int get fieldingExtras => byes + legByes;

  /// Display string showing the breakdown of extras (e.g., "w5 nb2 b1 lb3").
  String get displayString {
    final parts = <String>[];

    if (wides > 0) parts.add('w$wides');
    if (noBalls > 0) parts.add('nb$noBalls');
    if (byes > 0) parts.add('b$byes');
    if (legByes > 0) parts.add('lb$legByes');

    return parts.isEmpty ? '0' : parts.join(' ');
  }

  Extras addExtras({
    required bool isWide,
    required bool isNoBall,
    required bool isBye,
    required bool isLegBye,
    required int runs,
  }) {
    return Extras(
      wides: wides + (isWide ? runs : 0),
      noBalls: noBalls + (isNoBall ? runs : 0),
      byes: byes + (isBye ? runs : 0),
      legByes: legByes + (isLegBye ? runs : 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'wides': wides,
      'noBalls': noBalls,
      'byes': byes,
      'legByes': legByes,
    };
  }

  static Extras fromMap(Map<String, dynamic> map) {
    return Extras(
      wides: map['wides'] ?? 0,
      noBalls: map['noBalls'] ?? 0,
      byes: map['byes'] ?? 0,
      legByes: map['legByes'] ?? 0,
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
