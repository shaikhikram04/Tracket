import 'package:flutter/material.dart';
import 'package:tracket/matches/models/inning_data.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class BattingScorecard extends StatelessWidget {
  final InningsData innings;

  const BattingScorecard({
    super.key,
    required this.innings,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
    return [
      _StatColumn(
        title: 'R',
        values: innings.batsmen.map((b) => b.runs.toString()).toList(),
        width: 50,
      ),
      _StatColumn(
        title: 'B',
        values: innings.batsmen.map((b) => b.balls.toString()).toList(),
        width: 50,
      ),
      _StatColumn(
        title: "4's",
        values: innings.batsmen.map((b) => b.fours.toString()).toList(),
        width: 50,
      ),
      _StatColumn(
        title: "6's",
        values: innings.batsmen.map((b) => b.sixes.toString()).toList(),
        width: 50,
      ),
      _StatColumn(
        title: 'S/R',
        values: innings.batsmen
            .map((b) => b.strikeRate.toStringAsFixed(2))
            .toList(),
        width: 60,
      ),
    ];
  }
}

class _BattingColumn extends StatelessWidget {
  final InningsData innings;

  const _BattingColumn({required this.innings});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Batting'),
          const _Divider(),
          ...innings.batsmen.expand((batsman) => [
                Text(
                  batsman.name,
                  style: MyTextStyle(context).bodyLarge,
                ),
                Text(
                  batsman.dismissalInfo,
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
