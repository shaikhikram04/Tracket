import 'package:flutter/material.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class StatsData extends StatelessWidget {
  const StatsData({
    super.key,
    required this.number,
    required this.label,
    this.numColor = Colors.black,
  });

  final int number;
  final String label;
  final Color numColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number.toString(),
          style: MyTextStyle(context).coloredTitleLarge(numColor),
        ),
        Text(
          label,
          style: MyTextStyle(context).bodyLarge,
        ),
      ],
    );
  }
}
