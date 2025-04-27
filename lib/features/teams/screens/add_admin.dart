import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/buttons/action_button.dart';
import 'package:tracket/common/widgets/no_data_found.dart';
import 'package:tracket/features/players/widgets/player_list_view.dart';
import 'package:tracket/features/teams/models/team.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
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
        title: const Text(TTextStrings.addAdmin),
        backgroundColor: primaryColor,
        foregroundColor: onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: onPrimary),
            onPressed: () => _showAdminInfoDialog(context, isDark),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
        ],
      ),
      body: Column(
        children: [
          // Info Banner
          Container(
            padding: TPadding.md,
            color: primaryLight.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  color: isDark ? primaryLight : primaryColor,
                  size: TSizes.iconMd,
                ),
                const SizedBox(width: TSizes.md),
                Expanded(
                  child: Text(
                    TTextStrings.addAdminMessage,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: isDark
                              ? DarkThemeColors.primaryText
                              : LightThemeColors.primaryText,
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
                title: TTextStrings.noAvailablePlayers,
                message: TTextStrings.noAvailablePlayersMessage,
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
        title: const Text(
          TTextStrings.adminPrivileges,
        ),
        backgroundColor: isDark
            ? DarkThemeColors.surfaceColor
            : LightThemeColors.surfaceColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPrivilegeItem(
              context,
              Icons.edit,
              TTextStrings.manageTeamSettings,
              isDark,
            ),
            const SizedBox(height: TSizes.sm),
            _buildPrivilegeItem(
              context,
              Icons.person_add,
              TTextStrings.manageTeamMembers,
              isDark,
            ),
            const SizedBox(height: TSizes.sm),
            _buildPrivilegeItem(
              context,
              Icons.event,
              TTextStrings.manageTeamMatches,
              isDark,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              TTextStrings.gotItButton,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: isDark ? primaryLight : primaryColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivilegeItem(
      BuildContext context, IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: TSizes.iconMd,
          color: isDark ? primaryLight : primaryColor,
        ),
        const SizedBox(width: TSizes.md),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: isDark
                      ? DarkThemeColors.primaryText
                      : LightThemeColors.primaryText,
                ),
          ),
        ),
      ],
    );
  }
}
