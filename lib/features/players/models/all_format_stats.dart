import 'package:tracket/features/players/models/player_stats.dart';

class AllFormatStats {
  final PlayerStats over5;
  final PlayerStats over10;
  final PlayerStats over20;
  final PlayerStats over50;
  final PlayerStats test;

  const AllFormatStats({
    this.over5 = const PlayerStats(),
    this.over10 = const PlayerStats(),
    this.over20 = const PlayerStats(),
    this.over50 = const PlayerStats(),
    this.test = const PlayerStats(),
  });

  factory AllFormatStats.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AllFormatStats();

    return AllFormatStats(
      over5: PlayerStats.fromMap(json['over5']),
      over10: PlayerStats.fromMap(json['over10']),
      over20: PlayerStats.fromMap(json['over20']),
      over50: PlayerStats.fromMap(json['over50']),
      test: PlayerStats.fromMap(json['test']),
    );
  }

  Map<String, dynamic> get toJson => {
        'over5': over5.toJson,
        'over10': over10.toJson,
        'over20': over20.toJson,
        'over50': over50.toJson,
        'test': test.toJson,
      };
}
