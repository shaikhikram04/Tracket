import 'package:flutter/material.dart';

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
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: numColor,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
