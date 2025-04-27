import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/authentication/screens/auth_screen.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/home/drawer/drawer_header.dart';
import 'package:tracket/features/home/drawer/drawer_tile.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  Future<void> _logoutUser(BuildContext context) async {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final player = ref.watch(playerProvider);

    final isDark = THelperFunction.isDarkMode(context);

    return Drawer(
      backgroundColor: isDark
          ? DarkThemeColors.backgroundColor
          : LightThemeColors.backgroundColor,
      width: width * 0.75,
      child: Column(
        children: [
          MainDrawerHeader(player: player, width: width),
          DrawerTile(
            isDark: isDark,
            leadingIcon: Icons.logout,
            leadingIconColor: isDark ? Colors.red : Colors.redAccent.shade400,
            text: TTextStrings.logout,
            textColor: isDark ? Colors.red : Colors.redAccent.shade400,
            onTap: () => _logoutUser(context),
          ),
        ],
      ),
    );
  }
}
