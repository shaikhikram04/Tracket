import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/players/widgets/squad_player_tile.dart';
import 'package:tracket/teams/providers/providers.dart';
import 'package:tracket/teams/screens/add_player_screen.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/no_data_found.dart';

class Squad extends ConsumerWidget {
  const Squad({
    super.key,
    this.isEdit = false,
  });

  final bool isEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamState = ref.watch(teamProvider);
    final hasPlayers = teamState.team.playersList.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SquadHeader(
          isEdit: isEdit,
          onAddPlayer: () => _handleAddPlayer(context, ref),
        ),
        const SizedBox(height: 16),
        if (!hasPlayers)
          const _EmptySquadMessage()
        else
          _PlayersList(
            players: teamState.team.playersList,
            team: teamState.team,
            isEdit: isEdit,
            onDeletePlayer: (playerId) =>
                _showDeleteDialog(context, playerId, ref),
          ),
      ],
    );
  }

  void _handleAddPlayer(BuildContext context, WidgetRef ref) {
    ref.read(requestProvider.notifier).reset();
    pushScreen(
      context,
      AddPlayerScreen(team: ref.read(teamProvider).team),
    );
  }

  Future<void> _showDeleteDialog(
      BuildContext context, String playerId, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (context) => _DeletePlayerDialog(
        onConfirm: () => _handleDeletePlayer(context, playerId, ref),
      ),
    );
  }

  Future<void> _handleDeletePlayer(
      BuildContext context, String playerId, WidgetRef ref) async {
    await TeamsServices.deletePlayerFromTeam(playerId, ref, context);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _SquadHeader extends StatelessWidget {
  const _SquadHeader({
    required this.isEdit,
    required this.onAddPlayer,
  });

  final bool isEdit;
  final VoidCallback onAddPlayer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Squad',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          const Spacer(),
          if (isEdit) _AddPlayerButton(onPressed: onAddPlayer),
        ],
      ),
    );
  }
}

class _AddPlayerButton extends StatelessWidget {
  const _AddPlayerButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: 'Add Player',
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.group_add_rounded,
                  size: 28,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Add',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptySquadMessage extends StatelessWidget {
  const _EmptySquadMessage();

  @override
  Widget build(BuildContext context) {
    return const NoDataFound(
      title: 'No Player joined yet!',
      message: 'Tap the button above to request player to join.',
      isPointingButton: true,
    );
  }
}

class _PlayersList extends StatelessWidget {
  const _PlayersList({
    required this.players,
    required this.team,
    required this.isEdit,
    required this.onDeletePlayer,
  });

  final List<PlayerDetails> players;
  final dynamic team;
  final bool isEdit;
  final Function(String) onDeletePlayer;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListView.separated(
        key: ValueKey(players.length),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: players.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final player = players[index];
          final playerId = player.id;

          return SquadPlayerTile(
            key: ValueKey(playerId),
            cricketRole: player.cricketRole.name,
            playerId: playerId,
            playerName: player.name,
            profileImageUrl: player.imageUrl,
            teamRole: player.role,
            isCaptain: team.captainId == playerId,
            isWicketKeeper: team.wicketkeeperId == playerId,
            isEdit: isEdit,
            onDelete: () => onDeletePlayer(playerId),
          );
        },
      ),
    );
  }
}

class _DeletePlayerDialog extends StatelessWidget {
  const _DeletePlayerDialog({
    required this.onConfirm,
  });

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        'Delete Player',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this player?',
        style: theme.textTheme.bodyLarge,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: theme.textTheme.labelLarge,
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            'Delete',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
