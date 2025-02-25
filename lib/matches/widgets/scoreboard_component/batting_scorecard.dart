import 'package:flutter/material.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/extras.dart';
import 'package:tracket/matches/models/fall_of_wickets.dart';

class CricketColors {
  static const Color primaryColor = Color(0xFF1B5E20); // Dark green
  static const Color primaryVariant = Color(0xFF2E7D32); // Medium green
  static const Color secondaryColor = Color(0xFF43A047); // Light green
  static const Color pitchBrown = Color(0xFF8D6E63); // Brown
  static const Color lightPitchBrown = Color(0xFFBCAAA4); // Light brown
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color white = Colors.white;
  static const Color highlightYellow = Color(0xFFFFF59D);
}

class BattingScorecard extends StatelessWidget {
  final String teamName;
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
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: CricketColors.primaryColor, width: 1.5),
      ),
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTeamHeaderRow(),
          const Divider(height: 1, thickness: 1, color: CricketColors.divider),
          _ScrollableStatsSection(battingScore: battingScores),
          const Divider(height: 1, thickness: 1, color: CricketColors.divider),
          _buildExtrasRow(),
          const Divider(height: 1, thickness: 1, color: CricketColors.divider),
          _buildTotalRow(),
          if (fallOfWickets.isNotEmpty) ...[
            const Divider(
                height: 1, thickness: 1, color: CricketColors.divider),
            _buildFallOfWicketsRow(),
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
        color: CricketColors.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            teamName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CricketColors.white,
            ),
          ),
          Text(
            '$totalScore/$wickets$oversText',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CricketColors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the extras row showing byes, leg byes, wides, no balls, and penalties
  Widget _buildExtrasRow() {
    return Container(
      color: CricketColors.lightPitchBrown.withOpacity(0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Extras',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: CricketColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              '${extras.total} (b ${extras.byes}, lb ${extras.legByes}, w ${extras.wides}, '
              'nb ${extras.noBalls}, p ${extras.penaltyRuns})',
              style: const TextStyle(
                fontSize: 13,
                color: CricketColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the total score row
  Widget _buildTotalRow() {
    String oversText = ' in ${overs} overs';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: CricketColors.primaryVariant.withOpacity(0.15),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Total',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: CricketColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              '$totalScore for $wickets$oversText',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: CricketColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the fall of wickets row
  Widget _buildFallOfWicketsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fall of Wickets',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: CricketColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatFallOfWickets(),
            style: const TextStyle(
              fontSize: 13,
              color: CricketColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Formats the fall of wickets data into a readable string
  String _formatFallOfWickets() {
    return fallOfWickets.map((wicket) {
      String oversText = wicket.overs != null
          ? ' (${wicket.overs!.toStringAsFixed(1)} ov)'
          : '';
      return '${wicket.wicketNumber}-${wicket.runsAtFall} ${wicket.batsmanName}$oversText';
    }).join(' • ');
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
      _StatConfig('R', (b) => b.runs, 55),
      _StatConfig('B', (b) => b.ballsFaced, 55),
      _StatConfig("4s", (b) => b.fours, 45),
      _StatConfig("6s", (b) => b.sixes, 45),
      _StatConfig('S/R', (b) => b.strikeRate, 70,
          formatValue: (num? value) => value?.toStringAsFixed(1)),
    ];

    return statConfigs
        .map((config) => _StatColumn(
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
            color: CricketColors.lightPitchBrown.withOpacity(0.3),
            child: const Text(
              'BATSMAN',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: CricketColors.textSecondary,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: CricketColors.divider),
          ...Iterable.generate(
            battingScores.length,
            (index) {
              final batsman = battingScores[index];
              final isNotOut =
                  batsman.dismissalInfo.toLowerCase().contains('not out');
              final backgroundColor = index % 2 == 0
                  ? CricketColors.white
                  : CricketColors.lightPitchBrown.withOpacity(0.1);
              return Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                color: backgroundColor,
                height: 60,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        batsman.playerName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: CricketColors.textPrimary,
                          fontStyle:
                              isNotOut ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        batsman.dismissalInfo,
                        style: TextStyle(
                          fontSize: 12,
                          color: isNotOut
                              ? CricketColors.secondaryColor
                              : CricketColors.textSecondary,
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

class _StatColumn extends StatelessWidget {
  final String title;
  final List<String> values;
  final double width;

  const _StatColumn({
    required this.title,
    required this.values,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: CricketColors.lightPitchBrown.withOpacity(0.3),
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: CricketColors.textSecondary,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: CricketColors.divider),
          ...List.generate(values.length, (index) {
            final val = values[index];

            final backgroundColor = index % 2 == 0
                ? CricketColors.white
                : CricketColors.lightPitchBrown.withOpacity(0.1);
            return Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              color: backgroundColor,
              height: 60,
              child: Text(
                val,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: CricketColors.textPrimary,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
