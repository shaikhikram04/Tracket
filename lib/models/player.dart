enum CricketRole {
  batsman,
  bowler,
  allRounder,
  wicketKeeper,
}

class Player {
  Player({
    required this.name,
    required this.age,
    required this.role,
    this.matchesPlayed = 0,
    this.totalRuns = 0,
  });

  final String name;
  int age;
  CricketRole role;
  int matchesPlayed;
  int totalRuns;
}
