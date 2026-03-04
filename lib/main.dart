import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  runApp(
    const ProviderScope(child: Tracket()),
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
      home: currUser == null || !currUser.emailVerified ? const AuthScreen() : const HomeScreen(),

      // home: const Scaffold(
      //   body: ChatScreen(),
      // ),
    );
  }
}
