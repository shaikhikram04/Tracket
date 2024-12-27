import 'package:flutter/material.dart';
import 'package:tracket/players/models/player_stats.dart';
import 'package:tracket/players/widgets/stat_row.dart';

class BattingStats extends StatelessWidget {
  const BattingStats({super.key, required this.playerStats});

  final PlayerStats playerStats;

  @override
  Widget build(BuildContext context) {
    final notOut = playerStats.innings! - playerStats.outCount!;
    return Column(
      spacing: 15,
      children: [
        const SizedBox(height: 2),
        StatRow(stats: [
          {'number': playerStats.matches, 'label': 'Matches'},
          {'number': playerStats.innings, 'label': 'Innings'},
          {'number': playerStats.totalRuns, 'label': 'Runs'},
        ]),
        StatRow(stats: [
          {'number': playerStats.strikeRate, 'label': 'Strike Rate'},
          {'number': playerStats.battingAverage, 'label': 'Average'},
          {'number': playerStats.highestScore, 'label': 'Highest Score'},
        ]),
        StatRow(stats: [
          {'number': playerStats.hundreds, 'label': 'Hundreds'},
          {'number': playerStats.fifties, 'label': 'Fifties'},
          {'number': notOut, 'label': 'Not Outs'},
        ]),
        StatRow(stats: [
          {'number': playerStats.six, 'label': 'Sixes'},
          {'number': playerStats.four, 'label': 'Fours'},
        ]),
      ],
    );
  }
}
