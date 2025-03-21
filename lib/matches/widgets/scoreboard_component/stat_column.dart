import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class StatColumn extends StatelessWidget {
  final String title;
  final List<String> values;
  final double width;
  final double height;

  const StatColumn({
    required this.title,
    required this.values,
    required this.width,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: lightPitchBrown.withValues(alpha: 0.3),
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: LightThemeColors.secondaryText,
              ),
            ),
          ),
          const Divider(
              height: 1, thickness: 1, color: LightThemeColors.dividerColor),
          ...List.generate(values.length, (index) {
            final val = values[index];

            final backgroundColor = index % 2 == 0
                ? LightThemeColors.surfaceColor
                : lightPitchBrown.withValues(alpha: 0.1);
            return Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              color: backgroundColor,
              height: height,
              child: Text(
                val,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: LightThemeColors.primaryText,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
