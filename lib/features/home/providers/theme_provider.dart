import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(this._prefs) : super(ThemeMode.light) {
    _initializeTheme();
  }

  static const String _themeIsDarkKey = 'theme_is_dark';
  final SharedPreferences _prefs;

  void _initializeTheme() {
    final savedTheme = _prefs.getBool(_themeIsDarkKey);

    if (savedTheme != null) {
      state = savedTheme ? ThemeMode.dark : ThemeMode.light;
      return;
    }

    final isDeviceDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    state = isDeviceDark ? ThemeMode.dark : ThemeMode.light;
    _prefs.setBool(_themeIsDarkKey, isDeviceDark);
  }

  bool get isDarkMode => state == ThemeMode.dark;

  Future<void> setTheme({required bool isDark}) async {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
    await _prefs.setBool(_themeIsDarkKey, isDark);
  }

  Future<void> toggleTheme() async {
    await setTheme(isDark: !isDarkMode);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});
