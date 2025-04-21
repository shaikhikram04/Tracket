import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/features/authentication/screens/auth_screen.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/features/players/screens/player_profile_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final player = ref.watch(playerProvider);

    final isDark = THelperFunction.isDarkMode(context);

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
      backgroundColor: isDark
          ? DarkThemeColors.backgroundColor
          : LightThemeColors.backgroundColor,
      width: width * 0.75,
      child: Column(
        children: [
          DrawerHeader(
            padding: TPadding.lg,
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
                    ImageCircleAvatar(
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
                    TTextStrings.viewProfileButton,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
            tileColor: primaryColor.withValues(alpha: 0.1),
            leading: const Icon(
              Icons.logout,
              size: TSizes.iconMd,
              color: Colors.red,
            ),
            title: Text(
              TTextStrings.logout,
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
