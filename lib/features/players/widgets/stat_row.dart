import 'package:flutter/material.dart';
import 'package:tracket/features/players/widgets/stats_block.dart';

class StatRow extends StatelessWidget {
  const StatRow({super.key, required this.stats});

  final List<Map<String, dynamic>> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: stats.map((stat) {
        return StatsBlock(number: stat['number'], label: stat['label']);
      }).toList(),
    );
  }
}
