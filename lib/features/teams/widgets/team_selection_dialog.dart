import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/custom_widgets/my_text_button.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/features/teams/models/team_details.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class TeamSelectionDialog extends StatelessWidget {
  const TeamSelectionDialog({
    super.key,
    required this.teamList,
    this.title,
    this.subtitle,
  });

  final List<Map<String, dynamic>> teamList;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final isDark = THelperFunction.isDarkMode(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      ),
      elevation: 5,
      child: SizedBox(
        height: height * 0.5,
        child: Padding(
          padding: TPadding.md,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Center(
                child: Column(
                  children: [
                    THelperFunction.getTitleText(
                        title ?? TTextStrings.selectTeam, context),
                    Text(
                      TTextStrings.selectTeamSubtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),

              const SizedBox(height: TSizes.md),

              // Divider
              Divider(
                color: isDark
                    ? DarkThemeColors.dividerColor
                    : LightThemeColors.dividerColor,
              ),
              const SizedBox(height: TSizes.xs),

              // Teams list
              Expanded(
                child: ListView.separated(
                  itemCount: teamList.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: isDark
                        ? DarkThemeColors.dividerColor
                        : LightThemeColors.dividerColor,
                  ),
                  itemBuilder: (context, index) =>
                      _buildTeamItem(context, teamList[index]),
                ),
              ),

              // Bottom buttons
              const SizedBox(height: TSizes.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyTextButton(
                    text: TTextStrings.cancelButton,
                    onPressed: () => Navigator.of(context).pop(null),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamItem(BuildContext context, Map<String, dynamic> playerTeam) {
    final canChallenge = playerTeam['canChallenge'] as bool;
    final team = playerTeam['team'] as TeamDetails;
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canChallenge
            ? () => Navigator.of(context).pop(team)
            : () {
                THelperFunction.showAlertDialog(
                  context,
                  TTextStrings.alreadyChallenged,
                  TTextStrings.alreadyChallengedDesc,
                );
              },
        borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
        child: Container(
          padding: TPadding.sm,
          decoration: BoxDecoration(
            color: canChallenge ? Colors.transparent : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
          ),
          child: Row(
            spacing: TSizes.md,
            children: [
              // Team Avatar
              ImageCircleAvatar(
                url: team.logoUrl,
                isTeam: true,
                radius: TSizes.circleAvatarXsLg,
              ),

              // Team Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!canChallenge) ...[
                      const SizedBox(height: TSizes.xs),
                      Text(
                        TTextStrings.alreadyChallenged,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Team Short Name
              Container(
                padding: TPadding.xs,
                decoration: BoxDecoration(
                  color: canChallenge
                      ? theme.colorScheme.primaryContainer
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                ),
                child: Text(
                  team.shortName,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: canChallenge
                        ? theme.colorScheme.onPrimaryContainer
                        : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Status indicator
              if (canChallenge)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
