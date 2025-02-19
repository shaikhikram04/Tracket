import 'package:flutter/material.dart';
import 'package:tracket/players/widgets/player_list_view.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/widgets/custom_widgets/action_button.dart';
import 'package:tracket/widgets/no_data_found.dart';

class AddAdmin extends StatelessWidget {
  const AddAdmin({super.key, required this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? LightThemeColors.backgroundColor
          : DarkThemeColors.backgroundColor,
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
            onPressed: () => _showAdminInfoDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Info Banner
          Container(
            padding: const EdgeInsets.all(16),
            color: primaryLight.withOpacity(0.1),
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
                      color: Theme.of(context).brightness == Brightness.light
                          ? LightThemeColors.secondaryText
                          : DarkThemeColors.secondaryText,
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

              emptyStateWidget: NoDataFound(
                isRequest: false,
                title: 'No Available Players',
                message: 'All players are already administrators',

                // backgroundColor: Theme.of(context).brightness == Brightness.light
                //     ? LightThemeColors.cardColor
                //     : DarkThemeColors.cardColor,
                // textColor: Theme.of(context).brightness == Brightness.light
                //     ? LightThemeColors.primaryText
                //     : DarkThemeColors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAdminInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Privileges'),
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? LightThemeColors.surfaceColor
            : DarkThemeColors.surfaceColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPrivilegeItem(
              context,
              Icons.edit,
              'Manage team settings and details',
            ),
            const SizedBox(height: 8),
            _buildPrivilegeItem(
              context,
              Icons.person_add,
              'Add or remove team members',
            ),
            const SizedBox(height: 8),
            _buildPrivilegeItem(
              context,
              Icons.event,
              'Create and manage matches',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? primaryColor
                    : primaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivilegeItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).brightness == Brightness.light
              ? primaryColor
              : primaryLight,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? LightThemeColors.secondaryText
                  : DarkThemeColors.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}
