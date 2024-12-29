import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/authentication/auth_screen.dart';
import 'package:tracket/screens/home.dart';
import 'package:tracket/utils/colors.dart';

import 'firebase_options.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    surface: lightBackgroundColor,
    seedColor: greenColor,
  ),
  cardColor: lightCardColor,
  scaffoldBackgroundColor: lightBackgroundColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: greenColor,
    ),
  ),
  textTheme: GoogleFonts.rubikTextTheme().copyWith(
    titleLarge:
        GoogleFonts.rubik().copyWith(fontWeight: FontWeight.bold, fontSize: 26),
    titleMedium: GoogleFonts.rubik().copyWith(
      fontWeight: FontWeight.w900,
      fontSize: 17,
    ),
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    surface: darkBackgroundColor,
    seedColor: darkThemeColor,
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load();

  runApp(
    kIsWeb
        ? DevicePreview(
            backgroundColor: Colors.grey,
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
            builder: (BuildContext context) =>
                const ProviderScope(child: Tracket()),
          )
        : const ProviderScope(child: Tracket()),
  );
}

class Tracket extends StatelessWidget {
  const Tracket({super.key});

  @override
  Widget build(BuildContext context) {
    final currUser = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      title: 'Tracket',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      darkTheme: darkMode,
      themeMode: ThemeMode.light,
      home: currUser == null || !currUser.emailVerified
          ? const AuthScreen()
          : const HomeScreen(),
    );
  }
}
