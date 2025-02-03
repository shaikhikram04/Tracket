import 'package:flutter/material.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class BowlingScorecard extends StatelessWidget {
  final Inning innings;

  const BowlingScorecard({
    super.key,
    required this.innings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          _ScrollableStatsSection(innings),
        ],
      ),
    );
  }
}

class _ScrollableStatsSection extends StatelessWidget {
  const _ScrollableStatsSection(this.innings);

  final Inning innings;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BowlingColumn(innings: innings),
            ..._buildStatColumns(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStatColumns(BuildContext context) {
    final statConfigs = [
      _StatConfig('O', (b) => b.overs, 40,
          formatValue: (num? value) => value?.toStringAsFixed(1)),
      _StatConfig('M', (b) => b.maidenOvers, 40),
      _StatConfig('R', (b) => b.runsGiven, 40),
      _StatConfig('W', (b) => b.wickets, 40),
      _StatConfig('Econ', (b) => b.economy, 60,
          formatValue: (num? value) => value?.toStringAsFixed(2)),
    ];

    return statConfigs
        .map((config) => _StatColumn(
              title: config.title,
              values: innings.bowlingStats
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
  final Inning innings;

  const _BowlingColumn({required this.innings});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bowling'),
          const _Divider(),
          ...innings.bowlingStats.expand((bowler) => [
                Text(
                  bowler.playerName,
                  style: MyTextStyle(context).bodyLarge,
                ),
                const _Divider(),
              ]),
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
          Text(title),
          const _Divider(),
          ...values.expand((value) => [
                Text(
                  value,
                  style: MyTextStyle(context).bodyLarge,
                ),
                const _Divider(),
              ]),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 3),
      width: double.infinity,
      color: Colors.black38,
    );
  }
}

// Add this class to your models
class BowlerData {
  final String name;
  final double overs;
  final int maidens;
  final int runs;
  final int wickets;
  final double economy;

  const BowlerData({
    required this.name,
    required this.overs,
    required this.maidens,
    required this.runs,
    required this.wickets,
    required this.economy,
  });
}
