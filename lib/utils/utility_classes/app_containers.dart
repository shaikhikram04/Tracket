import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';

class AppContainers {
  static Container classicContainer({
    required Widget child,
    EdgeInsetsGeometry margin = AppPadding.contentPaddingXl,
    EdgeInsetsGeometry padding = AppPadding.xl,
    double radius = TSizes.radiusMd,
    double blurRadius = TSizes.radiusMd,
    Color color = Colors.white,
    Color shadowColor = primaryColor,
  }) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.15),
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
