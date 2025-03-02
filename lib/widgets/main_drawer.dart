import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/authentication/screens/auth_screen.dart';
import 'package:tracket/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final player = ref.watch(playerProvider);

    Future<void> logoutUser() async {
      try {
        await FirebaseAuthMethods().logout();

        if (!context.mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
          (route) => false,
        );
      } catch (e) {
        if (!context.mounted) return;

        showSnackBar(e.toString(), context);
      }
    }

    return Drawer(
      backgroundColor: LightThemeColors.backgroundColor,
      width: width * 0.7,
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  GradientColors.matchCardStart,
                  GradientColors.matchCardEnd,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                getCircleAvatar(
                  url: player.profileImageUrl,
                  isTeam: false,
                  radius: 40,
                  hasBorder: false,
                ),
                const SizedBox(width: 18),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: LightThemeColors.surfaceColor),
                    ),
                    Text(
                      player.role,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: LightThemeColors.surfaceColor),
                    )
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            tileColor: const Color.fromARGB(255, 221, 237, 221),
            leading: const Icon(
              Icons.logout,
              size: 26,
              color: Colors.red,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.red),
            ),
            onTap: logoutUser,
          ),
        ],
      ),
    );
  }
}
