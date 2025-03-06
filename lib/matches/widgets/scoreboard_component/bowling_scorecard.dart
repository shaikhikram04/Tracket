import 'package:flutter/material.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/extras.dart';
import 'package:tracket/matches/models/fall_of_wickets.dart';
import 'package:tracket/matches/widgets/scoreboard_component/batting_scorecard.dart';
import 'package:tracket/matches/widgets/scoreboard_component/stat_column.dart';
import 'package:tracket/utils/colors.dart';

class BowlingScorecard extends StatelessWidget {
  final List<BowlingScore> bowlerStats;
  final bool isDarkMode;

  const BowlingScorecard({
    super.key,
    required this.bowlerStats,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      color:
          isDarkMode ? DarkThemeColors.cardColor : LightThemeColors.cardColor,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Bowling Statistics',
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? DarkThemeColors.primaryText : primaryColor,
              ),
            ),
          ),

          // Scorecard header
          _ScrollableStatsSection(bowlingScores: bowlerStats),
        ],
      ),
    );
  }
}

class _ScrollableStatsSection extends StatelessWidget {
  const _ScrollableStatsSection({required this.bowlingScores});

  final List<BowlingScore> bowlingScores;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BowlingColumn(bowlingScores: bowlingScores),
            ..._buildStatColumns(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStatColumns(BuildContext context) {
    final statConfigs = [
      _StatConfig('O', (b) => b.overs, 60,
          formatValue: (num? value) => value?.toStringAsFixed(1)),
      _StatConfig('M', (b) => b.maidenOvers, 40),
      _StatConfig('R', (b) => b.runsGiven, 60),
      _StatConfig('W', (b) => b.wickets, 40),
      _StatConfig('Econ', (b) => b.economy, 70,
          formatValue: (num? value) => value?.toStringAsFixed(2)),
    ];

    return statConfigs
        .map((config) => StatColumn(
              title: config.title,
              values: bowlingScores
                  .map((b) =>
                      config.formatValue?.call(config.valueGetter(b)) ??
                      config.valueGetter(b)?.toString() ??
                      '-')
                  .toList(),
              width: config.width,
              height: 50,
            ))
        .toList();
  }
}

class _StatConfig<T> {
  final String title;
  final T? Function(BowlingScore) valueGetter;
  final double width;
  final String? Function(T?)? formatValue;

  const _StatConfig(
    this.title,
    this.valueGetter,
    this.width, {
    this.formatValue,
  });
}

class _BowlingColumn extends StatelessWidget {
  final List<BowlingScore> bowlingScores;

  const _BowlingColumn({required this.bowlingScores});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            width: double.infinity,
            height: 40,
            alignment: Alignment.centerLeft,
            color: lightPitchBrown.withValues(alpha: 0.3),
            child: const Text(
              'BOWLERS',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: LightThemeColors.secondaryText,
              ),
            ),
          ),
          const Divider(
              height: 1, thickness: 1, color: LightThemeColors.dividerColor),
          ...List.generate(
            bowlingScores.length,
            (index) {
              final bowler = bowlingScores[index];
              final isCurrentBowler = bowler.remainingBalls != 0;
              final backgroundColor = index % 2 == 0
                  ? LightThemeColors.surfaceColor
                  : lightPitchBrown.withValues(alpha: 0.1);
              return Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                color: backgroundColor,
                height: 50,
                child: Text(
                  bowler.playerName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: LightThemeColors.primaryText,
                    fontStyle:
                        isCurrentBowler ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
