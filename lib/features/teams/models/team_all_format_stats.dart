import 'package:tracket/features/teams/models/team_stats.dart';

class TeamAllFormatStats {
  const TeamAllFormatStats({
    this.over5 = const TeamStats(),
    this.over10 = const TeamStats(),
    this.over20 = const TeamStats(),
    this.over50 = const TeamStats(),
    this.test = const TeamStats(),
  });

  final TeamStats over5;
  final TeamStats over10;
  final TeamStats over20;
  final TeamStats over50;
  final TeamStats test;

  int get totalMatchPlayed =>
      over5.matchesPlayed +
      over10.matchesPlayed +
      over20.matchesPlayed +
      over50.matchesPlayed +
      test.matchesPlayed;
}
