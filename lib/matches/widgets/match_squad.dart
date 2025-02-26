import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/players/widgets/squad_player_tile.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class MatchSquad extends StatelessWidget {
  final String title;
  final List<MatchPlayerInfo> players;
  final bool isPlayerCanAdd;
  final Function()? onAddPlayer;
  final bool isLongCricketRole;
  final String captainId;
  final String wicketkeeperId;

  const MatchSquad({
    Key? key,
    this.title = 'Squad',
    required this.players,
    required this.captainId,
    required this.wicketkeeperId,
    this.isLongCricketRole = false,
    this.isPlayerCanAdd = false,
    this.onAddPlayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        _buildHeader(context, onAddPressed: onAddPlayer, iconSize: 20),
        _buildPlayersList(context),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    double? iconSize,
    required VoidCallback? onAddPressed,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: MyTextStyle(context).cardTitle.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        if (isPlayerCanAdd)
          IconButton(
            onPressed: onAddPressed,
            iconSize: iconSize,
            icon: const Icon(Icons.group_add),
          )
      ],
    );
  }

  Widget _buildPlayersList(BuildContext context) {
    if (players.isEmpty) {
      return _buildEmptyState(context);
    }

    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: players.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 70),
        itemBuilder: (context, index) {
          final player = players[index];
          return SquadPlayerTile(
            cricketRole: isLongCricketRole
                ? player.longCricketRole
                : player.cricketRole.name,
            playerId: player.playerId,
            playerName: player.playerName,
            profileImageUrl: player.profileImageUrl,
            isCaptain: captainId == player.playerId,
            isWicketKeeper: wicketkeeperId == player.playerId,
            isEdit: false,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Players Selected',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add players to create your match squad',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (isPlayerCanAdd) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAddPlayer,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Select Players'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
