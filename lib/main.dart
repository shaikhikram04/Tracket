import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tracket/features/authentication/screens/auth_screen.dart';
import 'package:tracket/features/home/screens/home.dart';
import 'package:tracket/utils/theme/theme.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
  );

  runApp(
    kIsWeb
        ? DevicePreview(
            backgroundColor: Colors.grey,
            enabled: true,
            defaultDevice: Devices.android.onePlus8Pro,
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
      themeMode: ThemeMode.dark,
      theme: TracketTheme.lightTheme,
      darkTheme: TracketTheme.darkTheme,
      title: 'Tracket',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: currUser == null || !currUser.emailVerified
          ? const AuthScreen()
          : const HomeScreen(),

      // home: const Scaffold(
      //   body: SafeArea(
      //     child: Column(
      //       children: [
      //         WinningStatusWidget(
      //           winningTeam: "Mumbai Indians",
      //           winningMargin: "Won by 5 wickets",
      //           animationPath: "assets/animations/trophy.json",
      //         ),
      //         SizedBox(height: 50),
      //         LossStatusWidget(
      //           losingTeam: "Chennai Super Kings",
      //           losingMargin: "Lost by 10 runs",
      //           animationPath: "assets/animations/sad_face.json",
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
