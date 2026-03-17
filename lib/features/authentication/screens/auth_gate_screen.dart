import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/features/authentication/screens/auth_screen.dart';
import 'package:tracket/features/authentication/screens/player_onboarding_screen.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/home/screens/home.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: CircularLoadingIndicator());
        }

        final user = authSnapshot.data;
        if (user == null) {
          return const AuthScreen();
        }

        return FutureBuilder<bool>(
          future: FirebaseAuthMethods.hasUserProfile(user.uid),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: CircularLoadingIndicator());
            }

            final hasProfile = profileSnapshot.data ?? false;
            if (hasProfile) {
              return const HomeScreen();
            }

            return const PlayerOnboardingScreen();
          },
        );
      },
    );
  }
}
