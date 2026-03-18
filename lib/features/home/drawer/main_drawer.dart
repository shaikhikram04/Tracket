import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracket/features/authentication/screens/auth_gate_screen.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/home/drawer/drawer_header.dart';
import 'package:tracket/features/home/drawer/drawer_tile.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  void _showDeletingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: const [
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              ),
              SizedBox(width: 12),
              Expanded(child: Text('Deleting account...')),
            ],
          ),
        ),
      ),
    );
  }

  void _hideDeletingDialog(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  Future<void> _logoutUser(BuildContext context) async {
    try {
      await FirebaseAuthMethods().logout();

      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthGateScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;

      THelperFunction.showSnackBar(e.toString(), context);
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(TTextStrings.deleteAccountTitle),
        content: const Text(TTextStrings.deleteAccountMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(TTextStrings.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              TTextStrings.deleteButton,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted) return;

    _showDeletingDialog(context);

    try {
      await FirebaseAuthMethods().deleteCurrentAccount();

      if (!context.mounted) return;
      _hideDeletingDialog(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthGateScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      _hideDeletingDialog(context);

      final message = e.code == 'requires-recent-login'
          ? 'Please sign in again and retry deleting your account.'
          : (e.message ?? e.code);
      THelperFunction.showSnackBar(message, context);
    } catch (e) {
      if (!context.mounted) return;

      _hideDeletingDialog(context);
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
          DrawerTile(
            isDark: isDark,
            leadingIcon: Icons.delete_forever_rounded,
            leadingIconColor: isDark ? Colors.redAccent : Colors.red.shade700,
            text: TTextStrings.deleteAccount,
            textColor: isDark ? Colors.redAccent : Colors.red.shade700,
            onTap: () => _deleteAccount(context),
          ),
        ],
      ),
    );
  }
}
