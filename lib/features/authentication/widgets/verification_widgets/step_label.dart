import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class StepLabel extends StatelessWidget {
  const StepLabel({
    super.key,
    required this.isActive,
    required this.label,
  });

  final bool isActive;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);
    final activeColor = isDark ? primaryLight : primaryColor;
    final inactiveColor =
        isDark ? DarkThemeColors.secondaryText : LightThemeColors.secondaryText;

    return Text(
      label,
      style: TextStyle(
        color: isActive ? activeColor : inactiveColor,
        fontSize: TSizes.fontSizeXs,
      ),
    );
  }
}
