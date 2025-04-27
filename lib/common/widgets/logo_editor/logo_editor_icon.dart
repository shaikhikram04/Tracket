import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class LogoEditorIcon extends StatelessWidget {
  const LogoEditorIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);
    
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        padding: TPadding.xxs,
        decoration: BoxDecoration(
          color: isDark ? lightGrassGreen : grassGreen,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark
                ? DarkThemeColors.surfaceColor
                : LightThemeColors.surfaceColor,
            width: 2,
          ),
        ),
        child: Icon(
          Icons.camera_alt,
          size: TSizes.iconSm,
          color: isDark
              ? DarkThemeColors.surfaceColor
              : LightThemeColors.surfaceColor,
        ),
      ),
    );
  }
}
