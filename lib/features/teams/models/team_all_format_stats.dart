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

  static TeamAllFormatStats fromJson(Map<String, dynamic>? json)  {
    if (json == null) return const TeamAllFormatStats();

    return TeamAllFormatStats(
      over5: TeamStats.fromJson(json['over5']),
      over10: TeamStats.fromJson(json['over10']),
      over20: TeamStats.fromJson(json['over20']),
      over50: TeamStats.fromJson(json['over50']),
      test: TeamStats.fromJson(json['test']),
    );
  }
}
