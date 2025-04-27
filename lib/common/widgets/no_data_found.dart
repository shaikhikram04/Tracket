import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({
    super.key,
    required this.title,
    required this.message,
    required this.iconData,
    this.isPointingButton = false,
    this.rotation = 0,
  });

  final String title;
  final String message;
  final IconData iconData;
  final bool isPointingButton;
  final int rotation;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return Center(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: TSizes.imageThumbSizeLg,
              color: isDark
                  ? DarkThemeColors.secondaryText
                  : LightThemeColors.secondaryText,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              title,
              style: TextStyle(
                fontSize: TSizes.fontSizeLg,
                color: isDark
                    ? DarkThemeColors.primaryText
                    : LightThemeColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              message,
              style: TextStyle(
                  fontSize: 16,
                  color: isDark
                      ? DarkThemeColors.secondaryText
                      : LightThemeColors.secondaryText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            if (isPointingButton)
              ZoomIn(
                child: RotatedBox(
                  quarterTurns: rotation,
                  child: Icon(
                    Icons.arrow_outward,
                    size: TSizes.iconXxl,
                    color: isDark ? primaryLight : Colors.green.shade400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
