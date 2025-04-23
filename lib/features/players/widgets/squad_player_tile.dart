import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/features/players/screens/player_profile_screen.dart';
import 'package:tracket/features/teams/models/team_role.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class SquadPlayerTile extends StatelessWidget {
  const SquadPlayerTile({
    super.key,
    required this.playerId,
    required this.playerName,
    required this.cricketRole,
    required this.profileImageUrl,
    this.teamRole = TeamRole.none,
    this.isCaptain = false,
    this.isWicketKeeper = false,
    this.isEdit = false,
    this.onDelete,
  });

  final String playerId;
  final String playerName;
  final String cricketRole;
  final String profileImageUrl;
  final TeamRole teamRole;
  final bool isCaptain;
  final bool isWicketKeeper;
  final bool isEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      color: isDark
          ? DarkThemeColors.secondaryBackground
          : LightThemeColors.secondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => THelperFunction.pushScreen(
            context, PlayerProfileScreen(playerId: playerId)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _PlayerAvatar(profileImageUrl: profileImageUrl),
              const SizedBox(width: 16),
              Expanded(
                child: _PlayerInfo(
                  playerName: playerName,
                  cricketRole: cricketRole,
                  isCaptain: isCaptain,
                  isWicketKeeper: isWicketKeeper,
                ),
              ),
              if (isEdit && teamRole != TeamRole.owner)
                _DeleteButton(onDelete: onDelete),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerAvatar extends StatelessWidget {
  const _PlayerAvatar({required this.profileImageUrl});

  final String profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'player_avatar_$profileImageUrl',
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ImageCircleAvatar(
          url: profileImageUrl,
          isTeam: false,
          radius: 30,
          hasBorder: false,
        ),
      ),
    );
  }
}

class _PlayerInfo extends StatelessWidget {
  const _PlayerInfo({
    required this.playerName,
    required this.cricketRole,
    required this.isCaptain,
    required this.isWicketKeeper,
  });

  final String playerName;
  final String cricketRole;
  final bool isCaptain;
  final bool isWicketKeeper;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = THelperFunction.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          playerName,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          cricketRole,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        if (isCaptain || isWicketKeeper) const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 2,
          children: [
            if (isCaptain)
              _RoleLabel(
                label: 'Captain',
                color: isDark
                    ? DarkThemeColors.batsmanColor
                    : LightThemeColors.batsmanColor,
                icon: Icons.star_rounded,
              ),
            if (isWicketKeeper)
              _RoleLabel(
                label: 'Wicketkeeper',
                color: isDark
                    ? DarkThemeColors.wicketKeeperColor
                    : LightThemeColors.wicketKeeperColor,
                icon: Icons.sports_cricket_rounded,
              ),
          ],
        ),
      ],
    );
  }
}

class _RoleLabel extends StatelessWidget {
  const _RoleLabel({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onDelete});

  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: 'Remove player',
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onDelete,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.delete_outline_rounded,
              size: 24,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ),
    );
  }
}
