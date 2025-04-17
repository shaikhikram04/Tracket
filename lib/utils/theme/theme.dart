import 'package:flutter/material.dart';

class TracketTheme {
  const TracketTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6200EE),
      secondary: Color(0xFF03DAC6),
      surface: Color(0xFFFFFFFF),
      background: Color(0xFFF5F5F5),
      error: Color(0xFFB00020),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFF000000),
      onSurface: Color(0xFF000000),
      onBackground: Color(0xFF000000),
      onError: Color(0xFFFFFFFF),
    ),
  );
}
