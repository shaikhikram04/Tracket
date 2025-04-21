import 'package:flutter/material.dart';
import 'package:tracket/features/matches/models/match_player_info.dart';
import 'package:tracket/features/players/widgets/squad_player_tile.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class MatchSquad extends StatelessWidget {
  final String title;
  final List<MatchPlayerInfo> players;
  final bool isPlayerCanAdd;
  final Function()? onAddPlayer;
  final bool isLongCricketRole;
  final String captainId;
  final String wicketkeeperId;
  final double titleSize;
  final double iconSize;

  const MatchSquad({
    Key? key,
    this.title = 'Squad',
    required this.players,
    required this.captainId,
    required this.wicketkeeperId,
    this.isLongCricketRole = false,
    this.isPlayerCanAdd = false,
    this.titleSize = 16,
    this.iconSize = 20,
    this.onAddPlayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context, onAddPressed: onAddPlayer, iconSize: iconSize),
        _buildPlayersList(context),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    double? iconSize,
    required VoidCallback? onAddPressed,
  }) {
    final isDark = THelperFunction.isDarkMode(context);
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: titleSize,
              ),
        ),
        const Spacer(),
        if (isPlayerCanAdd)
          IconButton(
            onPressed: onAddPressed,
            iconSize: iconSize,
            icon: Icon(
              Icons.group_add,
              color: isDark
                  ? DarkThemeColors.primaryText
                  : LightThemeColors.primaryText,
            ),
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
    final isDark = THelperFunction.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline,
                size: 48,
                color: isDark ? lightGrassGreen : darkGrassGreen,
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
                icon: Icon(
                  Icons.add_circle_outline,
                  color: isDark
                      ? DarkThemeColors.surfaceColor
                      : LightThemeColors.surfaceColor,
                ),
                label: const Text('Select Players'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? lightGrassGreen : darkGrassGreen,
                  foregroundColor: isDark
                      ? DarkThemeColors.surfaceColor
                      : LightThemeColors.surfaceColor,
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
