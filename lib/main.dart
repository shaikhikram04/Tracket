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
  runApp(const Tracket());
}

class Tracket extends StatelessWidget {
  const Tracket({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      home: const HomeScreen(),
    );
  }
}
