import 'package:flutter/material.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/teams/models/team_role.dart';
import 'package:tracket/widgets/custom_widgets/action_button.dart';
import 'package:tracket/widgets/custom_widgets/enhanced_list_tile.dart';

class PlayerListTile extends StatelessWidget {
  const PlayerListTile({
    super.key,
    required this.player,
    required this.team,
    required this.onTap,
    required this.isPrivate,
  });

  final PlayerDetails player;
  final Team team;
  final VoidCallback onTap;
  final bool isPrivate;

  @override
  Widget build(BuildContext context) {
    final teamInfo = TeamDetails(
      id: team.id,
      logoUrl: team.logoUrl,
      name: team.name,
      shortName: team.shortName,
      role: TeamRole.player,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: EnhancedListTile(
        imageUrl: player.imageUrl,
        title: player.name,
        subtitle: player.cricketRole.name,
        onTap: onTap,
        isPlayer: true,
        trailing: ActionButton(
          idsList: team.playerIds,
          isPrivate: isPrivate,
          buttonType: 'addPlayer',
          playerInfo: player,
          teamInfo: teamInfo,
          isTeamHasCapacity: team.hasCapacity,
        ),
      ),
    );
  }
}
