import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';

class TBottomNavigationBarTheme {
  static BottomNavigationBarThemeData lightBottomNavigationBarTheme =
      const BottomNavigationBarThemeData(
    backgroundColor: LightThemeColors.backgroundColor,
    selectedItemColor: primaryLight,
    unselectedItemColor: InteractiveColors.unselected,
    showSelectedLabels: true,
    type: BottomNavigationBarType.shifting,
    elevation: TSizes.cardElevationXxl,
    selectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );

  static BottomNavigationBarThemeData darkBottomNavigationBarTheme =
      const BottomNavigationBarThemeData(
    backgroundColor: DarkThemeColors.backgroundColor,
    selectedItemColor: InteractiveColors.selected,
    unselectedItemColor: InteractiveColors.unselected,
    showSelectedLabels: true,
    type: BottomNavigationBarType.shifting,
    elevation: TSizes.cardElevationXxl,
    selectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
}
