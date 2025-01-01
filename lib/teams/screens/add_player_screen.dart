import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/resources/firestore_methods.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/providers/request_status_provider.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_list_tile.dart';
import 'package:tracket/widgets/custom_widgets/my_small_elevated_button.dart';

class AddPlayerScreen extends StatefulWidget {
  const AddPlayerScreen({super.key, required this.team});

  final Team team;

  @override
  State<AddPlayerScreen> createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  late List<String> playersId;

  @override
  void initState() {
    playersId = widget.team.playersList
        .map((player) => player['id'].toString())
        .toList();
    super.initState();
  }

  void toggleAdding(String playerId, bool isAdding, WidgetRef ref) {
    if (isAdding) {
      ref.read(requestStatusProvider.notifier).addRequestInProgress(playerId);
    } else {
      ref.read(requestStatusProvider.notifier).addRequestSuccess(playerId);
    }
  }

  void addPlayer(
    String playerId,
    String playerName,
    String cricketRole,
    String? profileImageUrl,
    WidgetRef ref,
  ) async {
    toggleAdding(playerId, true, ref);
    try {
      final playerInfo = {
        'id': playerId,
        'name': playerName,
        'cricketRole': cricketRole,
        'imageUrl': profileImageUrl,
        'role': 'player',
      };
      final team = widget.team;
      final teamInfo = {
        'id': team.id,
        'name': team.name,
        'shortName': team.shortName,
        'logoUrl': team.logoUrl,
        'role': 'player',
      };
      await FirestoreMethods.addPlayerToTeam(
        playerInfo: playerInfo,
        teamInfo: teamInfo,
        ref: ref,
        context: context,
      );
    } finally {
      toggleAdding(playerId, false, ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Player'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('players')
            .where('role', isEqualTo: 'player')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong. Please try again later.'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Players Found'),
            );
          }
          final snap = snapshot.data!.docs;
          return ListView.builder(
            itemCount: snap.length,
            itemBuilder: (context, index) {
              final player = Player.fromSeed(snap[index].data(), null);
              return buildPlayerTile(player);
            },
          );
        },
      ),
    );
  }

  Widget buildPlayerTile(Player player) {
    final bool allowDirectTeamAdd = player.allowDirectTeamAdd!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: MyListTile(
        imageUrl: player.profileImageUrl,
        title: player.name,
        subtitle: player.cricketRole!.name,
        onTap: () => pushScreen(context, PlayerProfileScreen(player: player)),
        isPlayer: true,
        trailing: Consumer(
          builder: (context, ref, _) {
            final requestStatus = ref.watch(requestStatusProvider);
            final isRequestInProgress =
                requestStatus.requestInProgress.contains(player.id);
            final isRequestSuccess =
                requestStatus.requestSuccess.contains(player.id);

            final isAdded = playersId.contains(player.id) || isRequestSuccess;
            final buttonText = isAdded
                ? 'Added'
                : allowDirectTeamAdd
                    ? 'Add'
                    : 'Offer';
            return MySmallElevatedButton(
              isAdded: isAdded,
              onPressed: () => addPlayer(player.id, player.name,
                  player.cricketRole!.name, player.profileImageUrl, ref),
              isLoading: isRequestInProgress,
              buttonText: buttonText,
            );
          },
        ),
      ),
    );
  }
}
