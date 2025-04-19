import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/custom_widgets/action_button.dart';
import 'package:tracket/common/widgets/no_data_found.dart';
import 'package:tracket/features/players/widgets/player_list_view.dart';
import 'package:tracket/features/teams/models/team.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';

class AddAdmin extends StatelessWidget {
  const AddAdmin({super.key, required this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);
    return Scaffold(
      backgroundColor: isDark
          ? DarkThemeColors.backgroundColor
          : LightThemeColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Add Admin',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: onPrimary,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: onPrimary),
            onPressed: () => _showAdminInfoDialog(context, isDark),
          ),
        ],
      ),
      body: Column(
        children: [
          // Info Banner
          Container(
            padding: const EdgeInsets.all(16),
            color: primaryLight.withValues(alpha: 0.1),
            child: Row(
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  color: primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Select players to grant admin privileges',
                    style: TextStyle(
                      color: isDark
                          ? DarkThemeColors.primaryText
                          : LightThemeColors.primaryText,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Player List
          Expanded(
            child: PlayerListView(
              buttonType: ActionButtonType.addAdmin,
              players: team.nonAdmins,
              team: team,
              emptyStateWidget: const NoDataFound(
                iconData: AppIconData.groupOff,
                title: 'No Available Players',
                message: 'All players are already administrators',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAdminInfoDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Privileges'),
        backgroundColor: isDark
            ? DarkThemeColors.surfaceColor
            : LightThemeColors.surfaceColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPrivilegeItem(
              Icons.edit,
              'Manage team settings and details',
              isDark,
            ),
            const SizedBox(height: 8),
            _buildPrivilegeItem(
              Icons.person_add,
              'Add or remove team members',
              isDark,
            ),
            const SizedBox(height: 8),
            _buildPrivilegeItem(
              Icons.event,
              'Create and manage matches',
              isDark,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: TextStyle(
                color: isDark ? primaryLight : primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivilegeItem(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? primaryLight : primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isDark
                  ? DarkThemeColors.secondaryText
                  : LightThemeColors.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}
