import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class AppContainers {
  static Container classicContainer({
    required Widget child,
    required BuildContext context,
    EdgeInsetsGeometry margin = TPadding.hPaddingXl,
    EdgeInsetsGeometry padding = TPadding.xl,
    double radius = TSizes.borderRadiusXxl,
    double blurRadius = TSizes.blurRadiusXl,
  }) {
    final isDark = THelperFunction.isDarkMode(context);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: isDark
            ? DarkThemeColors.surfaceColor
            : LightThemeColors.surfaceColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.15),
            blurRadius: blurRadius,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}
