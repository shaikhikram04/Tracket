import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/features/notifications/screens/challenge_screen.dart';
import 'package:tracket/features/notifications/screens/request_screen.dart';
import 'package:tracket/features/players/models/player_details.dart';
import 'package:tracket/features/players/screens/player_profile_screen.dart';
import 'package:tracket/features/players/services/players_services.dart';
import 'package:tracket/features/teams/models/team_role.dart';
import 'package:tracket/features/teams/providers/providers.dart';
import 'package:tracket/features/teams/providers/team_state.dart';
import 'package:tracket/features/teams/screens/add_admin.dart';
import 'package:tracket/features/teams/services/teams_services.dart';
import 'package:tracket/features/teams/widgets/privacy_settings.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';

class TeamSettingsScreen extends ConsumerWidget {
  const TeamSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamState = ref.watch(teamProvider);
    final isDark = THelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Team Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: onPrimary,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems),
          child: Column(
            spacing: TSizes.spaceBtwItems,
            children: [
              _buildAdminsSection(context, ref, teamState),
              _buildRequestsSection(context, teamState),
              _buildPrivacySection(context, ref, teamState),
              _buildDangerZone(context, teamState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminsSection(
      BuildContext context, WidgetRef ref, TeamState teamState) {
    final isDark = THelperFunction.isDarkMode(context);
    return _SectionCard(
      title: 'Team Administrators',
      titleIcon: Icons.admin_panel_settings,
      action: IconButton(
        onPressed: () {
          ref.read(requestProvider.notifier).reset();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAdmin(team: teamState.team),
            ),
          );
        },
        icon:
            Icon(Icons.person_add, color: isDark ? primaryLight : primaryColor),
      ),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: teamState.team.admins.length,
            separatorBuilder: (_, __) => const Divider(height: 0.5),
            itemBuilder: (context, index) {
              final admin = teamState.team.admins[index];
              return _AdminListTile(
                admin: admin,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PlayerProfileScreen(playerId: admin.id),
                  ),
                ),
                onRemove: admin.role != TeamRole.owner
                    ? () => _showRemoveAdminDialog(
                        context, ref, admin.id, teamState.team.id, admin.name)
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsSection(BuildContext context, TeamState teamState) {
    return _SectionCard(
      title: 'Request & Challenge Management',
      titleIcon: Icons.manage_accounts_outlined,
      child: Column(
        children: [
          _RequestTile(
            icon: Icons.group_add_rounded,
            title: 'Requests',
            count: teamState.team.requestStatus.pendingRequest,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RequestScreen(teamId: teamState.team.id),
              ),
            ),
          ),
          const Divider(height: 1),
          _RequestTile(
            icon: Icons.sports_cricket,
            title: 'Challenges',
            count: teamState.team.requestStatus.sendRequest,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChallengeScreen(teamId: teamState.team.id),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(
      BuildContext context, WidgetRef ref, TeamState teamState) {
    return _SectionCard(
      title: 'Privacy Settings',
      titleIcon: Icons.security,
      child: PrivacySettings(
        isTeamPrivate: teamState.team.isPrivate,
        onSwitchChanged: (newValue) => _handlePrivacyChange(
          context,
          ref,
          teamState.team.id,
          newValue,
        ),
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context, TeamState teamState) {
    return _SectionCard(
      title: 'Danger Zone',
      titleIcon: Icons.warning,
      backgroundColor: StatusColors.error.withValues(alpha: 0.1),
      titleColor: StatusColors.error,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.delete_forever, color: StatusColors.error),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delete Team',
                    style: TextStyle(
                      color: StatusColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This action cannot be undone.',
                    style: TextStyle(
                      color: StatusColors.error.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            CustomButton.secondary(
              onPressed: () =>
                  _showDeleteTeamDialog(context, teamState.team.id),
              text: 'Delete',
              textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: StatusColors.error, fontWeight: FontWeight.w600),
              backgroundColor: InteractiveColors.buttonDisabledSecondary,
              borderColor: StatusColors.error,
              size: ButtonSize.small,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePrivacyChange(
      BuildContext context, WidgetRef ref, String teamId, bool newValue) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newValue
              ? 'Team is now private. New members require approval.'
              : 'Team is now public. Anyone can join directly.',
        ),
      ),
    );

    await TeamsServices.updateTeamPrivacy(
      context,
      teamId: teamId,
      isPrivate: newValue,
    );
    ref.read(teamProvider.notifier).updateField(isTeamPrivate: newValue);
  }

  void _showRemoveAdminDialog(BuildContext context, WidgetRef ref,
      String adminId, String teamId, String adminName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Admin'),
        content:
            Text('Are you sure you want to remove $adminName as an admin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              PlayersServices.changePlayerTeamRole(
                playerId: adminId,
                teamId: teamId,
                newRole: TeamRole.player,
                ref: ref,
                context: context,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: StatusColors.error,
              foregroundColor: onPrimary,
              side: const BorderSide(color: StatusColors.error),
            ),
            child: Text('Remove',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: onPrimary)),
          ),
        ],
      ),
    );
  }

  void _showDeleteTeamDialog(BuildContext context, String teamId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Team'),
        content: const Text(
          'This action cannot be undone. All team data, including matches and statistics, will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              TeamsServices.deleteTeam(context, teamId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: StatusColors.error,
              foregroundColor: onPrimary,
              side: const BorderSide(color: StatusColors.error),
            ),
            child: Text('Delete',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: onPrimary)),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    required this.titleIcon,
    this.action,
    this.backgroundColor,
    this.titleColor,
  });

  final String title;
  final Widget child;
  final IconData titleIcon;
  final Widget? action;
  final Color? backgroundColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunction.isDarkMode(context);

    final bgColor = isDarkMode
        ? DarkThemeColors.surfaceColor
        : LightThemeColors.surfaceColor;

    final fgColor = isDarkMode ? primaryLight : primaryColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  titleIcon,
                  color: titleColor ?? fgColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: titleColor ??
                          (isDarkMode
                              ? DarkThemeColors.primaryText
                              : LightThemeColors.primaryText),
                    ),
                  ),
                ),
                if (action != null) action!,
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _AdminListTile extends StatelessWidget {
  const _AdminListTile({
    required this.admin,
    required this.onTap,
    this.onRemove,
  });

  final PlayerDetails admin; // Replace with your actual admin model type
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunction.isDarkMode(context);

    final pColor = isDarkMode ? primaryLight : primaryColor;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      leading: ImageCircleAvatar(
        url: admin.imageUrl,
        isTeam: false,
        radius: 24,
        hasBorder: false,
      ),
      title: Text(
        admin.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        admin.role.name,
        style: TextStyle(
          color: admin.role == TeamRole.owner ? pColor : null,
        ),
      ),
      trailing: onRemove != null
          ? CustomButton.secondary(
              onPressed: onRemove!,
              text: 'Remove',
              textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: StatusColors.error, fontWeight: FontWeight.w600),
              backgroundColor: LightThemeColors.surfaceColor,
              borderColor: StatusColors.error,
              size: ButtonSize.small,
            )
          : null,
    );
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({
    required this.icon,
    required this.title,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDarkMode ? primaryLight : primaryColor),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode
              ? DarkThemeColors.primaryText
              : LightThemeColors.primaryText,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: isDarkMode ? primaryLight : primaryVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
