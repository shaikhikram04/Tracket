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
