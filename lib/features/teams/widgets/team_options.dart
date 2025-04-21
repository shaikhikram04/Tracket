import 'package:flutter/material.dart';
import 'package:tracket/features/teams/screens/team_edit_screen.dart';
import 'package:tracket/features/teams/screens/team_settings_screen.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class TeamOptions extends StatelessWidget {
  const TeamOptions({
    super.key,
    required this.isOwner,
  });

  final bool isOwner;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 8, 15, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              TTextStrings.teamOptions,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: TSizes.xl),
            _buildOptionTile(
              context: context,
              icon: Icons.edit_rounded,
              iconColor: Colors.blue.shade400,
              title: TTextStrings.editTeamDetails,
              subtitle: TTextStrings.editTeamDetailsDescription,
              onTap: () {
                Navigator.of(context).pop();
                THelperFunction.pushScreen(context, const TeamEditScreen());
              },
            ),
            if (isOwner) ...[
              const SizedBox(height: TSizes.sm),
              _buildOptionTile(
                context: context,
                icon: Icons.settings_rounded,
                iconColor: Colors.green.shade400,
                title: TTextStrings.teamSettings,
                subtitle: TTextStrings.teamSettingsDescription,
                onTap: () {
                  Navigator.of(context).pop();
                  THelperFunction.pushScreen(
                      context, const TeamSettingsScreen());
                },
              ),
            ],
            const SizedBox(height: 8),
            _buildOptionTile(
              context: context,
              icon: Icons.close_rounded,
              iconColor: Colors.red.shade400,
              title: TTextStrings.closeButton,
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
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
      contentPadding: TPadding.listTilePaddingSm,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.borderRadiusLg)),
      leading: Container(
        padding: TPadding.xs,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
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
