import 'package:flutter/material.dart';
import 'package:tracket/features/matches/models/bowling_score.dart';
import 'package:tracket/features/matches/widgets/scoreboard_component/stat_column.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class BowlingScorecard extends StatelessWidget {
  final List<BowlingScore> bowlerStats;

  const BowlingScorecard({
    super.key,
    required this.bowlerStats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final isDark = THelperFunction.isDarkMode(context);

    return Card(
      elevation: 2,
      color: isDark
          ? DarkThemeColors.secondaryBackground
          : LightThemeColors.secondaryBackground,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8.0),
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
                color: isDark
                    ? DarkThemeColors.primaryText
                    : LightThemeColors.primaryText,
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
      _StatConfig('O', (b) => b.balls, 60, formatValue: (num? balls) {
        int overs = balls!.toInt() ~/ 6;
        int remainingBalls = balls.toInt() % 6;

        if (remainingBalls == 0) {
          return overs.toString();
        }
        return '$overs.${remainingBalls}';
      }),
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
    final isDark = THelperFunction.isDarkMode(context);

    final oddBgColor = isDark
        ? lightPitchBrown.withValues(alpha: 0.3)
        : lightPitchBrown.withValues(alpha: 0.1);

    final evenBgColor =
        isDark ? DarkThemeColors.surfaceColor : LightThemeColors.surfaceColor;

    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            width: double.infinity,
            height: 40,
            alignment: Alignment.centerLeft,
            color: isDark
                ? lightPitchBrown.withValues(alpha: 0.5)
                : lightPitchBrown.withValues(alpha: 0.3),
            child: Text(
              'BOWLERS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? DarkThemeColors.primaryText
                    : LightThemeColors.secondaryText,
              ),
            ),
          ),
          Divider(
              height: 1,
              thickness: 1,
              color: isDark
                  ? DarkThemeColors.dividerColor
                  : LightThemeColors.dividerColor),
          ...List.generate(
            bowlingScores.length,
            (index) {
              final bowler = bowlingScores[index];
              final isCurrentBowler = bowler.remainingBalls != 0;
              final backgroundColor = index % 2 == 0 ? evenBgColor : oddBgColor;
              return Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                color: backgroundColor,
                height: 50,
                child: Text(
                  bowler.playerName,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? DarkThemeColors.primaryText
                        : LightThemeColors.primaryText,
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
