import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';

class TracketTheme {
  const TracketTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Rubik',
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: LightThemeColors.backgroundColor,
    
  );
}
