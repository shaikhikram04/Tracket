enum Role {
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
    required this.matchesPlayed,
    required this.totalRuns,
  });

  final String name;
  int age;
  Role role;
  int matchesPlayed;
  int totalRuns;
}
