import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/highlighted_label.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class TeamListTile extends StatelessWidget {
  const TeamListTile({
    super.key,
    required this.teamData,
    required this.teamRole,
    required this.onTap,
  });

  final Map<String, dynamic> teamData;
  final TeamRole teamRole;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunction.isDarkMode(context);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ImageCircleAvatar(
        url: teamData['logoUrl'],
        isTeam: true,
        radius: 28,
        hasBorder: false,
      ),
      title: Text(
        teamData['teamName'],
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDarkMode ? DarkThemeColors.primaryText : LightThemeColors.primaryText,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            teamData['shortName'],
            style: TextStyle(
              color: isDarkMode ? DarkThemeColors.secondaryText : LightThemeColors.secondaryText,
            ),
          ),
          if (teamRole != TeamRole.player) ...[
            const SizedBox(height: TSizes.xs),
            HighlightedLabel(
              text: teamRole.name,
              size: HighlightSize.small,
              color: isDarkMode ? DarkThemeColors.primaryText : primaryColor,
            ),
          ],
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
