import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

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
    final isDark = THelperFunction.isDarkMode(context);

    final oddBgColor = isDark
        ? lightPitchBrown.withValues(alpha: 0.3)
        : lightPitchBrown.withValues(alpha: 0.1);

    final evenBgColor =
        isDark ? DarkThemeColors.surfaceColor : LightThemeColors.surfaceColor;

    return SizedBox(
      width: width,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: isDark
                ? lightPitchBrown.withValues(alpha: 0.5)
                : lightPitchBrown.withValues(alpha: 0.3),
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? DarkThemeColors.primaryText
                    : LightThemeColors.primaryText,
              ),
            ),
          ),
          Divider(
              height: 1,
              thickness: 1,
              color: isDark
                  ? DarkThemeColors.dividerColor
                  : LightThemeColors.dividerColor),
          ...List.generate(values.length, (index) {
            final val = values[index];

            final backgroundColor = index % 2 == 0 ? evenBgColor : oddBgColor;
            return Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              color: backgroundColor,
              height: height,
              child: Text(
                val,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: isDark
                      ? DarkThemeColors.primaryText
                      : LightThemeColors.primaryText,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
