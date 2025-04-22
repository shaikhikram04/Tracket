import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/theme/custom_theme/app_bar_theme.dart';
import 'package:tracket/utils/theme/custom_theme/bottom_navigation_bar_theme.dart';
import 'package:tracket/utils/theme/custom_theme/bottom_sheet_theme.dart';
import 'package:tracket/utils/theme/custom_theme/chip_theme.dart';
import 'package:tracket/utils/theme/custom_theme/elevated_button_theme.dart';
import 'package:tracket/utils/theme/custom_theme/outline_button_theme.dart';
import 'package:tracket/utils/theme/custom_theme/slider_theme.dart';
import 'package:tracket/utils/theme/custom_theme/tab_bar_theme.dart';
import 'package:tracket/utils/theme/custom_theme/text_field_theme.dart';
import 'package:tracket/utils/theme/custom_theme/text_theme.dart';

class TracketTheme {
  const TracketTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Rubik',
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: grassGreen,
      error: Colors.red,
    ),
    scaffoldBackgroundColor: LightThemeColors.backgroundColor,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    chipTheme: TChipTheme.lightChipTheme,
    inputDecorationTheme: TTextFieldTheme.lightInputDecorationTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    bottomNavigationBarTheme:
        TBottomNavigationBarTheme.lightBottomNavigationBarTheme,
    sliderTheme: TSliderTheme.lightSliderTheme,
    tabBarTheme: TTabBarTheme.light,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Rubik',
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryLight,
      secondary: secondaryLight,
      tertiary: lightGrassGreen,
      error: Colors.redAccent,
    ),
    scaffoldBackgroundColor: DarkThemeColors.backgroundColor,
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    chipTheme: TChipTheme.darkChipTheme,
    inputDecorationTheme: TTextFieldTheme.darkInputDecorationTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    bottomNavigationBarTheme:
        TBottomNavigationBarTheme.darkBottomNavigationBarTheme,
    sliderTheme: TSliderTheme.darkSliderTheme,
    tabBarTheme: TTabBarTheme.dark,
  );
}
