import 'package:flutter/material.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class BattingScorecard extends StatelessWidget {
  final Inning innings;

  const BattingScorecard({
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
          _ExtrasAndTotalSection(),
          _FallOfWickets(),
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
            _BattingColumn(innings: innings),
            ..._buildStatColumns(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStatColumns(BuildContext context) {
    final statConfigs = [
      _StatConfig('R', (b) => b.runs, 40),
      _StatConfig('B', (b) => b.ballsFaced, 40),
      _StatConfig("4's", (b) => b.fours, 40),
      _StatConfig("6's", (b) => b.sixes, 40),
      _StatConfig('S/R', (b) => b.strikeRate, 60,
          formatValue: (num? value) => value?.toStringAsFixed(2)),
    ];

    return statConfigs
        .map((config) => _StatColumn(
              title: config.title,
              values: innings.battingStats
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

class _ExtrasAndTotalSection extends StatelessWidget {
  const _ExtrasAndTotalSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(
          label: 'Extras',
          value: '6  (W 1, LB 5)',
        ),
        const _Divider(),
        _InfoRow(
          label: 'Total runs',
          value: '121  (5 wkts, 10 ovs)',
        ),
        const _Divider(),
      ],
    );
  }
}

class _FallOfWickets extends StatelessWidget {
  const _FallOfWickets();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            'Fall of wickets',
            style: MyTextStyle(context).bodyLarge,
          ),
        ),
        _buildWicketsList(context),
        const SizedBox(height: 6),
        const _Divider(),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildWicketsList(BuildContext context) {
    final wickets = [
      _WicketInfo(score: '12/1', player: 'Batsman1', overs: '1.2'),
      _WicketInfo(score: '12/1', player: 'Batsman1', overs: '1.2'),
      _WicketInfo(score: '12/1', player: 'Batsman1', overs: '1.2'),
      _WicketInfo(score: '12/1', player: 'Batsman1', overs: '1.2'),
    ];

    return Text.rich(
      TextSpan(
        children: wickets
            .expand((wicket) => [
                  TextSpan(text: wicket.score),
                  TextSpan(
                    text: '  (${wicket.player}, ${wicket.overs} ovs)',
                    style: MyTextStyle(context)
                        .coloredBodyMedium(Colors.grey.shade600),
                  ),
                  if (wicket != wickets.last) const TextSpan(text: '  •  '),
                ])
            .toList(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 215,
          height: 35,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: MyTextStyle(context).bodyLarge,
            ),
          ),
        ),
        Text(
          value,
          style: MyTextStyle(context).boldBodyLarge,
        ),
      ],
    );
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

class _WicketInfo {
  final String score;
  final String player;
  final String overs;

  const _WicketInfo({
    required this.score,
    required this.player,
    required this.overs,
  });
}

class _BattingColumn extends StatelessWidget {
  final Inning innings;

  const _BattingColumn({required this.innings});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Batting'),
          const _Divider(),
          ...innings.battingStats.expand((batsman) => [
                Text(
                  batsman.playerName,
                  style: MyTextStyle(context).bodyLarge,
                ),
                Text(
                  'batsman.dismissalInfo',
                  style: MyTextStyle(context)
                      .bodyMedium
                      .copyWith(color: Colors.grey.shade600),
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
                const Text(''),
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
