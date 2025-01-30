import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/players/widgets/player_tile.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/widgets/no_data_found.dart';

class MatchSquad extends StatelessWidget {
  const MatchSquad({
    super.key,
    required this.selectedPlayers,
    required this.captainId,
    required this.wicketkeeperId,
    this.onAddPressed,
    this.isPlayerCanAdd = true,
    this.title = 'Squad',
  });

  static const double _titleFontSize = 23.0;
  static const double _iconSize = 30.0;
  static const double _verticalSpacing = 10.0;

  final List<MatchPlayerInfo> selectedPlayers;
  final String captainId;
  final String wicketkeeperId;
  final VoidCallback? onAddPressed;
  final bool isPlayerCanAdd;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context),
        const SizedBox(height: _verticalSpacing),
        _buildPlayersList(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: MyTextStyle(context).titleMedium.copyWith(
                fontSize: _titleFontSize,
              ),
        ),
        const Spacer(),
        if (isPlayerCanAdd)
          IconButton(
            onPressed: onAddPressed,
            iconSize: _iconSize,
            icon: const Icon(Icons.group_add),
          )
      ],
    );
  }

  Widget _buildPlayersList() {
    if (selectedPlayers.isEmpty) {
      return NoDataFound(
        title: 'No Player selected yet!',
        message: isPlayerCanAdd ? 'Tap the button above to select player.' : '',
        isPointingButton: isPlayerCanAdd,
      );
    }

    return Column(
      children:
          selectedPlayers.map((player) => _buildPlayerTile(player)).toList(),
    );
  }

  Widget _buildPlayerTile(MatchPlayerInfo player) {
    return PlayerTile(
      cricketRole: player.cricketRole,
      playerId: player.playerId,
      playerName: player.playerName,
      profileImageUrl: player.profileImageUrl,
      isCaptain: captainId == player.playerId,
      isWicketKeeper: wicketkeeperId == player.playerId,
      isEdit: false,
    );
  }
}
