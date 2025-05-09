import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/buttons/action_button.dart';
import 'package:tracket/common/widgets/list_view/enhanced_list_tile.dart';
import 'package:tracket/features/players/models/player_details.dart';
import 'package:tracket/features/teams/models/team.dart';
import 'package:tracket/features/teams/models/team_details.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/constants/paddings.dart';

class PlayerListTile extends StatelessWidget {
  const PlayerListTile({
    super.key,
    required this.player,
    required this.team,
    required this.onTap,
    required this.isPrivate,
    required this.buttonType,
    this.showRoleIcon = true,
    this.backgroundColor,
    this.avatarRadius = 30,
    this.buttonMinWidth = 95,
  });

  final PlayerDetails player;
  final Team team;
  final VoidCallback onTap;
  final bool isPrivate;
  final bool showRoleIcon;
  final Color? backgroundColor;
  final double avatarRadius;
  final double buttonMinWidth;
  final ActionButtonType buttonType;

  TeamDetails get _teamInfo => TeamDetails(
        id: team.id,
        logoUrl: team.logoUrl,
        name: team.name,
        shortName: team.shortName,
        role: TeamRole.player,
      );

  Widget _buildActionButton() {
    return ActionButton(
      idsList: team.playerIds,
      isPrivate: isPrivate,
      buttonType: buttonType,
      playerInfo: player,
      teamInfo: _teamInfo,
      isTeamHasCapacity: team.hasCapacity,
      minWidth: buttonMinWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TPadding.paddingXs,
      child: Material(
        type: MaterialType.transparency,
        child: EnhancedListTile(
          imageUrl: player.imageUrl,
          title: player.name,
          onTap: onTap,
          isPlayer: true,
          avatarRadius: avatarRadius,
          backgroundColor: backgroundColor,
          trailing: _buildActionButton(),
          subtitle: player.cricketRole.name,
        ),
      ),
    );
  }
}
