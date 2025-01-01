import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/resources/firestore_methods.dart';
import 'package:tracket/teams/providers/request_status_provider.dart';
import 'package:tracket/teams/providers/team_provider.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_list_tile.dart';

class AddAdmin extends ConsumerWidget {
  const AddAdmin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.read(teamProvider);
    final nonAdminPlayers = team.nonAdmins;

    void toggleAdding(String playerId, bool isAdding) {
      if (isAdding) {
        ref.read(requestStatusProvider.notifier).addRequestInProgress(playerId);
      } else {
        ref.read(requestStatusProvider.notifier).addRequestSuccess(playerId);
      }
    }

    void addAdmin(String playerId) {
      toggleAdding(playerId, true);

      try {
        FirestoreMethods.addAdminToTeam(
          playerId: playerId,
          teamId: team.id,
          ref: ref,
          context: context,
        );
      } finally {
        toggleAdding(playerId, false);
      }
    }

    final requestStatus = ref.watch(requestStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Admin'),
      ),
      body: nonAdminPlayers.isNotEmpty
          ? ListView.builder(
              itemCount: nonAdminPlayers.length,
              itemBuilder: (context, index) {
                final player = nonAdminPlayers[index];
                final isRequestInProgress =
                    requestStatus.requestInProgress.contains(player['id']);
                final isRequestSuccess =
                    requestStatus.requestSuccess.contains(player['id']);

                return MyListTile(
                  imageUrl: player['imageUrl'],
                  title: player['name'],
                  subtitle: player['cricketRole'],
                  onTap: () => pushScreen(
                      context, PlayerProfileScreen(playerId: player['id'])),
                  isPlayer: true,
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isRequestSuccess ? Colors.grey : buttonBgColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onPressed: (isRequestSuccess || isRequestInProgress)
                        ? null
                        : () => addAdmin(player['id']),
                    child: isRequestInProgress
                        ? const CircularProgressIndicator()
                        : Text(
                            isRequestSuccess ? 'Added' : 'Add',
                            style: const TextStyle(color: blackColor),
                          ),
                  ),
                );
              },
            )
          : const Center(
              child: Text('No players to add as admin'),
            ),
    );
  }
}
