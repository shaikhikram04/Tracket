import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tracket/common/widgets/highlighted_label.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/common/widgets/no_data_found.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/features/teams/models/team_role.dart';
import 'package:tracket/features/teams/screens/create_team_screen.dart';
import 'package:tracket/features/teams/screens/explore_teams.dart';
import 'package:tracket/features/teams/screens/join_team_screen.dart';
import 'package:tracket/features/teams/screens/team_profile_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = THelperFunction.isDarkMode(context);

    final player = ref.watch(playerProvider);
    final playerTeamsId = [
      ...player.playerTeamsId,
      '',
    ]; // Create new list with empty string

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .where('id', whereIn: playerTeamsId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingState();
          }

          if (snapshot.hasError) {
            return _ErrorState(error: snapshot.error.toString());
          }

          if (!snapshot.hasData || snapshot.data!.size == 0) {
            return const _EmptyState();
          }

          return _TeamsList(
            teams: snapshot.data!.docs,
            player: player,
          );
        },
      ),
      floatingActionButton: _buildSpeedDial(context, player, isDark: isDark),
    );
  }

  Widget _buildSpeedDial(BuildContext context, dynamic player,
      {required bool isDark}) {
    return SpeedDial(
      backgroundColor: primaryColor,
      foregroundColor: onPrimary,
      animatedIcon: AnimatedIcons.menu_close,
      overlayOpacity: 0.45,
      overlayColor: Colors.black,
      animationDuration: const Duration(milliseconds: 280),
      animationCurve: Curves.easeInOut,
      renderOverlay: true,
      children: [
        _buildSpeedDialChild(
          icon: Icons.group_add,
          label: TTextStrings.joinTeam,
          onTap: () => _navigateToScreen(context, JoinTeamScreen(player)),
          isDark: isDark,
        ),
        _buildSpeedDialChild(
          icon: Icons.create,
          label: TTextStrings.createTeam,
          onTap: () => _navigateToScreen(context, const CreateTeamScreen()),
          isDark: isDark,
        ),
        _buildSpeedDialChild(
          icon: Icons.explore,
          label: TTextStrings.exploreTeams,
          onTap: () => _navigateToScreen(context, const ExploreTeams()),
          isDark: isDark,
        ),
      ],
    );
  }

  SpeedDialChild _buildSpeedDialChild({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return SpeedDialChild(
      child: Icon(icon, color: isDark ? lightGrassGreen : darkGrassGreen),
      backgroundColor:
          isDark ? DarkThemeColors.cardColor : LightThemeColors.cardColor,
      label: label,
      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
      labelBackgroundColor:
          isDark ? DarkThemeColors.cardColor : LightThemeColors.cardColor,
      onTap: onTap,
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: primaryColor),
          const SizedBox(height: 16),
          Text(
            'Loading your teams...',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? DarkThemeColors.secondaryText
                  : LightThemeColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: StatusColors.error.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkThemeColors.primaryText
                    : LightThemeColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkThemeColors.secondaryText
                    : LightThemeColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const NoDataFound(
      title: 'No Team Yet',
      message: 'Join or create a team to get started',
      isPointingButton: true,
      rotation: 1,
      iconData: AppIconData.groupOff,
    );
  }
}

class _TeamsList extends StatelessWidget {
  const _TeamsList({
    required this.teams,
    required this.player,
  });

  final List<QueryDocumentSnapshot> teams;
  final dynamic player;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: teams.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final teamData = teams[index].data() as Map<String, dynamic>;
        final teamRole = player.playerCricketDetails!.teams
            .firstWhere((team) => team.id == teamData['id'])
            .role;

        return _TeamListTile(
          teamData: teamData,
          teamRole: teamRole,
          onTap: () => THelperFunction.pushScreen(
              context, TeamProfileScreen(teamData: teamData)),
        );
      },
    );
  }
}

class _TeamListTile extends StatelessWidget {
  const _TeamListTile({
    required this.teamData,
    required this.teamRole,
    required this.onTap,
  });

  final Map<String, dynamic> teamData;
  final TeamRole teamRole;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
          color: isDarkMode
              ? DarkThemeColors.primaryText
              : LightThemeColors.primaryText,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            teamData['shortName'],
            style: TextStyle(
              color: isDarkMode
                  ? DarkThemeColors.secondaryText
                  : LightThemeColors.secondaryText,
            ),
          ),
          if (teamRole != TeamRole.player) ...[
            const SizedBox(height: 4),
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
