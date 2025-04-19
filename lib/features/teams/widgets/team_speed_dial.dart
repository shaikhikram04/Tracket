import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/features/teams/screens/create_team_screen.dart';
import 'package:tracket/features/teams/screens/explore_teams.dart';
import 'package:tracket/features/teams/screens/join_team_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class TeamSpeedDial extends StatelessWidget {
  const TeamSpeedDial({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

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
