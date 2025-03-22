import 'package:flutter/material.dart';
import 'package:tracket/players/models/player_stats.dart';
import 'package:tracket/players/widgets/stat_row.dart';

class BattingStats extends StatelessWidget {
  const BattingStats({super.key, required this.playerStats});

  final PlayerStats playerStats;

  @override
  Widget build(BuildContext context) {
    final notOut = playerStats.battingStats.innings! - playerStats.battingStats.outCount!;
    return Column(
      spacing: 15,
      children: [
        const SizedBox(height: 2),
        StatRow(stats: [
          {'number': playerStats.matches, 'label': 'Matches'},
          {'number': playerStats.battingStats.innings, 'label': 'Innings'},
          {'number': playerStats.battingStats.totalRuns, 'label': 'Runs'},
        ]),
        StatRow(stats: [
          {'number': playerStats.battingStats.strikeRate, 'label': 'Strike Rate'},
          {'number': playerStats.battingStats.battingAverage, 'label': 'Average'},
          {'number': playerStats.battingStats.highestScore, 'label': 'Highest Score'},
        ]),
        StatRow(stats: [
          {'number': playerStats.battingStats.hundreds, 'label': 'Hundreds'},
          {'number': playerStats.battingStats.fifties, 'label': 'Fifties'},
          {'number': notOut, 'label': 'Not Outs'},
        ]),
        StatRow(stats: [
          {'number': playerStats.battingStats.six, 'label': 'Sixes'},
          {'number': playerStats.battingStats.four, 'label': 'Fours'},
        ]),
      ],
    );
  }
}
