import 'package:tracket/players/models/batting_stats.dart';
import 'package:tracket/players/models/bowling_stats.dart';

class PlayerStats {
  PlayerStats({
    this.matches = 0,
    this.battingStats = const BattingStats(),
    this.bowlingStats = const BowlingStats(),
  }) : userId = null;

  const PlayerStats.matchStats({
    required this.userId,
    this.battingStats = const BattingStats.matchStats(),
    this.bowlingStats = const BowlingStats.matchStats(),
  }) : matches = null;

  //* Identifing user uniquely
  final String? userId;

  final int? matches;
  final BattingStats battingStats;
  final BowlingStats? bowlingStats;

  Map<String, dynamic> get toJson => {
        'matches': matches,
        'battingStats': battingStats.toJson,
        'bowlingStats': bowlingStats?.toJson,
      };

  static PlayerStats fromMap(Map<String, dynamic> snap) {
    return PlayerStats(
      matches: snap['matches'],
      battingStats: BattingStats.fromMap(snap['battingStats']),
      bowlingStats: snap['bowlingStats'] == null
          ? null
          : BowlingStats.fromMap(snap['bowlingStats']),
    );
  }
}
