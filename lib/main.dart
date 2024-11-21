import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/screens/home.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    surface: const Color.fromARGB(255, 247, 250, 247),
    seedColor: Colors.green,
  ),
  cardColor: const Color.fromARGB(255, 218, 239, 220),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
    ),
  ),
  textTheme: GoogleFonts.rubikTextTheme().copyWith(
    titleLarge: GoogleFonts.rubik().copyWith(fontWeight: FontWeight.bold),
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    surface: const Color.fromRGBO(33, 33, 33, 1),
    seedColor: const Color(0xFF1FE073),
  ),
);

void main() {
  runApp(DevicePreview(
    backgroundColor: Colors.white,
    enabled: true,
    defaultDevice: Devices.ios.iPhone13ProMax,
    isToolbarVisible: true,
    availableLocales: const [Locale('en', 'US')],
    tools: const [
      DeviceSection(
        model: true,
        orientation: false,
        frameVisibility: false,
        virtualKeyboard: false,
      ),
    ],
    devices: [
      Devices.android.samsungGalaxyA50,
      Devices.android.samsungGalaxyNote20,
      Devices.android.samsungGalaxyS20,
      Devices.android.samsungGalaxyNote20Ultra,
      Devices.android.onePlus8Pro,
      Devices.android.sonyXperia1II,
      Devices.ios.iPhoneSE,
      Devices.ios.iPhone12,
      Devices.ios.iPhone12Mini,
      Devices.ios.iPhone12ProMax,
      Devices.ios.iPhone13,
      Devices.ios.iPhone13ProMax,
      Devices.ios.iPhone13Mini,
      Devices.ios.iPhoneSE,
    ],
    builder: (BuildContext context) => const Tracket(),
  ));
}

class Tracket extends StatelessWidget {
  const Tracket({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
