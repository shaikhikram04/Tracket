import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/resources/firestore_methods.dart';
import 'package:tracket/teams/providers/team_provider.dart';
import 'package:tracket/teams/screens/add_player_screen.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/player_tile.dart';

class Squad extends ConsumerWidget {
  const Squad({
    super.key,
    this.isEdit = false,
  });

  final bool isEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamProvider);
    final teamId = team.id;

    void addPlayer() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const AddPlayerScreen(),
      ));
    }

    Future<void> deletePlayer(
      Map<String, dynamic> playerInfo,
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
                final teamInfo = {
                  'id': team.id,
                  'name': team.name,
                  'shortName': team.shortName,
                  'logoUrl': team.logoUrl,
                  'role': playerInfo['role'],
                };
                try {
                  await FirestoreMethods.deletePlayerFromTeam(
                      playerInfo, teamInfo, ref);
                } catch (e) {
                  if (context.mounted) {
                    showSnackBar(e.toString(), context);
                  }
                } finally {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Squad',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 23),
              ),
              const Spacer(),
              IconButton(
                onPressed: addPlayer,
                iconSize: 30,
                icon: const Icon(Icons.group_add),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        team.playersList.isEmpty
            ? Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.group_off,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "No Player joined yet!",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Tap the button above to request player to join.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ZoomIn(
                      child: Icon(
                        Icons.arrow_outward,
                        size: 50,
                        color: Colors.green.shade400,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: List.generate(
                team.playersList.length,
                (index) {
                  final playerDetail = team.playersList[index];
                  final playerId = playerDetail['id'];
                  final isCaptain = team.captainId == null
                      ? false
                      : team.captainId == playerId;
                  final isWicketKeeper = team.wicketKeeperId == null
                      ? false
                      : team.wicketKeeperId == playerId;
                  return PlayerTile(
                    playerData: playerDetail,
                    isCaptain: isCaptain,
                    isWicketKeeper: isWicketKeeper,
                    isEdit: isEdit,
                    teamId: teamId,
                    onDelete: () => deletePlayer(
                      playerDetail,
                    ),
                  );
                },
              )),
      ],
    );
  }
}
