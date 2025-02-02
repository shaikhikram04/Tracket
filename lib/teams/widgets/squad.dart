import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/widgets/squad_player_tile.dart';
import 'package:tracket/teams/providers/providers.dart';
import 'package:tracket/teams/screens/add_player_screen.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
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

    void addPlayer() {
      ref.read(requestProvider.notifier).reset();
      pushScreen(
          context,
          AddPlayerScreen(
            team: teamState.team,
          ));
    }

    Future<void> deletePlayer(
      String playerId,
    ) async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Player'),
          content: const Text('Are you sure you want to delete this player?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await TeamsServices.deletePlayerFromTeam(
                  playerId,
                  ref,
                  context,
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'Squad',
              style: MyTextStyle(context).titleMedium.copyWith(fontSize: 23),
            ),
            const Spacer(),
            if (isEdit)
              IconButton(
                onPressed: addPlayer,
                iconSize: 30,
                icon: const Icon(Icons.group_add),
              )
          ],
        ),
        const SizedBox(height: 10),
        teamState.team.playersList.isEmpty
            ? const NoDataFound(
                title: 'No Player joined yet!',
                message: 'Tap the button above to request player to join.',
                isPointingButton: true)
            : Column(
                children: List.generate(
                  teamState.team.playersList.length,
                  (index) {
                    final playerDetail = teamState.team.playersList[index];
                    final playerId = playerDetail.id;
                    final isCaptain = teamState.team.captainId == playerId;
                    final isWicketKeeper =
                        teamState.team.wicketkeeperId == playerId;
                    return SquadPlayerTile(
                      cricketRole: playerDetail.cricketRole,
                      playerId: playerId,
                      playerName: playerDetail.name,
                      profileImageUrl: playerDetail.imageUrl,
                      teamRole: playerDetail.role,
                      isCaptain: isCaptain,
                      isWicketKeeper: isWicketKeeper,
                      isEdit: isEdit,
                      onDelete: () => deletePlayer(playerId),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
