import 'package:flutter/material.dart';
import 'package:tracket/features/matches/models/batting_score.dart';
import 'package:tracket/features/matches/models/extras.dart';
import 'package:tracket/features/matches/models/fall_of_wickets.dart';
import 'package:tracket/features/matches/models/match_player_info.dart';
import 'package:tracket/features/matches/widgets/scoreboard_component/stat_column.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class BattingScorecard extends StatelessWidget {
  final String teamName;
  final List<MatchPlayerInfo> allPlayers;
  final List<BattingScore> battingScores;
  final Extras extras;
  final int totalScore;
  final int wickets;
  final String overs;
  final List<FallOfWicket> fallOfWickets;

  const BattingScorecard({
    super.key,
    required this.teamName,
    required this.battingScores,
    required this.extras,
    required this.totalScore,
    required this.wickets,
    required this.overs,
    required this.fallOfWickets,
    required this.allPlayers,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: grassGreen, width: 1.5),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTeamHeaderRow(),
          const Divider(
              height: 1, thickness: 1, color: LightThemeColors.dividerColor),
          _ScrollableStatsSection(battingScore: battingScores),
          const Divider(
              height: 1, thickness: 1, color: LightThemeColors.dividerColor),
          _buildExtrasRow(isDark),
          const Divider(
              height: 1, thickness: 1, color: LightThemeColors.dividerColor),
          _buildTotalRow(isDark),
          if (allPlayers.length > battingScores.length) ...[
            const Divider(
                height: 1, thickness: 1, color: LightThemeColors.dividerColor),
            _buildYetToBatRow(isDark),
          ],
          if (fallOfWickets.isNotEmpty) ...[
            const Divider(
                height: 1, thickness: 1, color: LightThemeColors.dividerColor),
            _buildFallOfWicketsRow(isDark),
          ],
        ],
      ),
    );
  }

  /// Builds the team name and score header row
  Widget _buildTeamHeaderRow() {
    String oversText = ' (${overs} ov)';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: grassGreen,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
        children: [
          Flexible(
            child: Text(
              teamName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: LightThemeColors.surfaceColor,
              ),
            ),
          ),
          Text(
            '$totalScore/$wickets$oversText',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: LightThemeColors.surfaceColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the extras row showing byes, leg byes, wides, no balls, and penalties
  Widget _buildExtrasRow(bool isDark) {
    return Container(
      color: isDark
          ? lightPitchBrown.withValues(alpha: 0.3)
          : lightPitchBrown.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        spacing: 10,
        children: [
          Text(
            'Extras',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? DarkThemeColors.primaryText
                  : LightThemeColors.primaryText,
            ),
          ),
          Expanded(
            child: Text(
              '${extras.total} (${extras.displayString})',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? DarkThemeColors.primaryText
                    : LightThemeColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the total score row
  Widget _buildTotalRow(bool isDark) {
    String oversText = ' in ${overs} overs';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isDark
          ? primaryLight.withValues(alpha: 0.15)
          : primaryVariant.withValues(alpha: 0.15),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Total',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? DarkThemeColors.primaryText
                    : LightThemeColors.primaryText,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              '$totalScore for $wickets$oversText',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? lightGrassGreen : grassGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYetToBatRow(bool isDark) {
    final yetToBat = allPlayers
        .where((player) => !battingScores.any((b) => b.uuid == player.playerId))
        .map((player) => player.playerName)
        .join(' • ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yet to Bat',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? DarkThemeColors.primaryText
                  : LightThemeColors.primaryText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            yetToBat,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? DarkThemeColors.secondaryText
                  : LightThemeColors.secondaryText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the fall of wickets row
  Widget _buildFallOfWicketsRow(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fall of Wickets',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? DarkThemeColors.primaryText
                  : LightThemeColors.primaryText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            FallOfWicket.formatWicketsList(fallOfWickets),
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? DarkThemeColors.secondaryText
                  : LightThemeColors.secondaryText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollableStatsSection extends StatelessWidget {
  const _ScrollableStatsSection({required this.battingScore});

  final List<BattingScore> battingScore;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BattingColumn(battingScores: battingScore),
            ..._buildStatColumns(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStatColumns(BuildContext context) {
    final statConfigs = [
      _StatConfig('R', (b) => b.runs, 45),
      _StatConfig('B', (b) => b.ballsFaced, 45),
      _StatConfig("4s", (b) => b.fours, 45),
      _StatConfig("6s", (b) => b.sixes, 45),
      _StatConfig('S/R', (b) => b.strikeRate, 70,
          formatValue: (num? value) => value?.toStringAsFixed(1)),
    ];

    return statConfigs
        .map((config) => StatColumn(
              title: config.title,
              values: battingScore
                  .map((b) =>
                      config.formatValue?.call(config.valueGetter(b)) ??
                      config.valueGetter(b)?.toString() ??
                      '-')
                  .toList(),
              width: config.width,
            ))
        .toList();
  }
}

class _StatConfig<T> {
  final String title;
  final T? Function(BattingScore) valueGetter;
  final double width;
  final String? Function(T?)? formatValue;

  const _StatConfig(
    this.title,
    this.valueGetter,
    this.width, {
    this.formatValue,
  });
}

class _BattingColumn extends StatelessWidget {
  final List<BattingScore> battingScores;

  const _BattingColumn({required this.battingScores});

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
              'BATSMEN',
              maxLines: 1,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
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
          ...Iterable.generate(
            battingScores.length,
            (index) {
              final batsman = battingScores[index];
              final isNotOut = !batsman.isOut;
              final backgroundColor = index % 2 == 0 ? evenBgColor : oddBgColor;
              return Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                color: backgroundColor,
                height: 65,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        batsman.playerName,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          color: isDark
                              ? DarkThemeColors.primaryText
                              : LightThemeColors.primaryText,
                          fontStyle:
                              isNotOut ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isNotOut ? 'Not Out' : batsman.dismissalInfo,
                        style: TextStyle(
                          fontSize: 12,
                          color: isNotOut
                              ? primaryLight
                              : isDark
                                  ? DarkThemeColors.secondaryText
                                  : LightThemeColors.secondaryText,
                        ),
                      ),
                    ]),
              );
            },
          ).toList(),
        ],
      ),
    );
  }
}
