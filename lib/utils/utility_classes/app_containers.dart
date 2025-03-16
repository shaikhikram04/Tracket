import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';

class AppContainers {
  Container clasicContainer({
    required Widget child,
    EdgeInsetsGeometry margin = AppPadding.contentPaddingXl,
    EdgeInsetsGeometry padding = AppPadding.xl,
    double radius = AppSize.radiusMd,
    double blurRadius = AppSize.radiusMd,
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
