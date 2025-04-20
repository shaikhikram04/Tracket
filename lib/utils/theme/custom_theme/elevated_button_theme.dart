import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/theme/custom_theme/text_theme.dart';

class TElevatedButtonTheme {
  const TElevatedButtonTheme._();

  static ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 6,
      backgroundColor: primaryColor,
      foregroundColor: LightThemeColors.surfaceColor,
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: const BorderSide(color: primaryColor),
      padding: const EdgeInsets.symmetric(vertical: 12),
      textStyle: TTextTheme.lightTextTheme.titleMedium,
    ),
  );

  static ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 6,
      backgroundColor: primaryColor,
      foregroundColor: LightThemeColors.surfaceColor,
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: const BorderSide(color: primaryColor),
      padding: const EdgeInsets.symmetric(vertical: 12),
      textStyle: TTextTheme.darkTextTheme.titleMedium,
    ),
  );
}
