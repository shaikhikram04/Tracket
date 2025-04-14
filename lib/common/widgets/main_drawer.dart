import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/authentication/screens/auth_screen.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/features/players/screens/player_profile_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

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

        THelperFunction.showSnackBar(e.toString(), context);
      }
    }

    return Drawer(
      backgroundColor: LightThemeColors.backgroundColor,
      width: width * 0.75,
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  GradientColors.matchCardStart,
                  GradientColors.matchCardEnd,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    THelperFunction.getCircleAvatar(
                      url: player.profileImageUrl,
                      isTeam: false,
                      radius: width * 0.085,
                      hasBorder: false,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => THelperFunction.pushScreen(
                      context,
                      PlayerProfileScreen(
                        player: player,
                      )),
                  child: Text(
                    'View Profile',
                    style: MyTextStyle(context).bodyLarge.copyWith(
                          color: onPrimary,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1,
                          decoration: TextDecoration.underline,
                          decorationColor: onPrimary,
                        ),
                  ),
                )
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
