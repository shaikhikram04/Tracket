import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/authentication/screens/auth_gate_screen.dart';
import 'package:tracket/utils/theme/theme.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.setLanguageCode('en');

  await dotenv.load();

  runApp(
    const ProviderScope(child: Tracket()),
  );
}

class Tracket extends StatelessWidget {
  const Tracket({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: TracketTheme.lightTheme,
      darkTheme: TracketTheme.darkTheme,
      title: 'Tracket',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const AuthGateScreen(),
    );
  }
}
