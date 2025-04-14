import 'package:flutter/material.dart';
import 'package:tracket/features/teams/screens/team_edit_screen.dart';
import 'package:tracket/features/teams/screens/team_settings_screen.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class TeamOptions extends StatelessWidget {
  const TeamOptions({
    super.key,
    required this.isOwner,
  });

  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bottom sheet drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Team Options',
                style: MyTextStyle(context).headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              _buildOptionTile(
                context: context,
                icon: Icons.edit_rounded,
                iconColor: Colors.blue.shade400,
                title: 'Edit Team Details',
                subtitle: 'Modify team information and preferences',
                onTap: () {
                  Navigator.of(context).pop();
                  THelperFunction.pushScreen(context, const TeamEditScreen());
                },
              ),
              if (isOwner) ...[
                const SizedBox(height: 8),
                _buildOptionTile(
                  context: context,
                  icon: Icons.settings_rounded,
                  iconColor: Colors.green.shade400,
                  title: 'Team Settings',
                  subtitle: 'Manage team configuration and permissions',
                  onTap: () {
                    Navigator.of(context).pop();
                    THelperFunction.pushScreen(context, const TeamSettingsScreen());
                  },
                ),
              ],
              const SizedBox(height: 8),
              _buildOptionTile(
                context: context,
                icon: Icons.close_rounded,
                iconColor: Colors.red.shade400,
                title: 'Close',
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Theme.of(context).hintColor))
          : null,
      onTap: onTap,
    );
  }
}
