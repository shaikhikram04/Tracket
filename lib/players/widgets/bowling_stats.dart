import 'package:flutter/material.dart';
import 'package:tracket/players/models/player_stats.dart';
import 'package:tracket/players/widgets/stat_row.dart';

class BowlingStats extends StatelessWidget {
  const BowlingStats({super.key, required this.playerStats});

  final PlayerStats playerStats;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 15),
        StatRow(stats: [
          {'number': playerStats.matches, 'label': 'Matches'},
          {'number': playerStats.wicket, 'label': 'Wickets'},
          {'number': playerStats.economyRate, 'label': 'Economy'},
        ]),

        const SizedBox(height: 30),
        StatRow(stats: [
          {'number': playerStats.bowlingAverage, 'label': 'Average'},
          {
            'number': playerStats.bestBallingFigure!.inString,
            'label': 'Best Bowling',
          },
        ]),

        // Add more bowling stats
      ],
    );
  }
}
