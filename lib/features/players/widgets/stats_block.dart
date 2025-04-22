import 'package:flutter/material.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class StatsBlock extends StatelessWidget {
  const StatsBlock({super.key, this.number, required this.label});

  final dynamic number;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return Expanded(
      child: Column(
        children: [
          Text(
            number.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Text(
            label,
            style: TextStyle(
                fontSize: 14, color: isDark ? Colors.white54 : Colors.black54),
          ),
        ],
      ),
    );
  }
}
