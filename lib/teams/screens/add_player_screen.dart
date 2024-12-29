import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/resources/firestore_methods.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/providers/request_status_provider.dart';
import 'package:tracket/teams/providers/team_provider.dart';
import 'package:tracket/utils/colors.dart';

class AddPlayerScreen extends ConsumerStatefulWidget {
  const AddPlayerScreen({super.key});

  @override
  ConsumerState<AddPlayerScreen> createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends ConsumerState<AddPlayerScreen> {
  late Team _team;

  @override
  void initState() {
    _team = ref.read(teamProvider);
    super.initState();
  }

  void toggleAdding(String playerId, bool isAdding) {
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
  ) async {
    toggleAdding(playerId, true);
    try {
      final playerInfo = {
        'id': playerId,
        'name': playerName,
        'cricketRole': cricketRole,
        'imageUrl': profileImageUrl,
        'role': 'player',
      };
      final teamInfo = {
        'id': _team.id,
        'name': _team.name,
        'shortName': _team.shortName,
        'logoUrl': _team.logoUrl,
        'role': 'player',
      };
      await FirestoreMethods.addPlayerToTeam(
        playerInfo: playerInfo,
        teamInfo: teamInfo,
        ref: ref,
        context: context,
      );
    } finally {
      toggleAdding(playerId, false);
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
              final player = Player.fromSeed(snap[index].data());
              return buildPlayerTile(player);
            },
          );
        },
      ),
    );
  }

  Widget buildPlayerTile(Player player) {
    final List teamsId =
        player.teams!.map((team) => team['id'].toString()).toList();

    final bool allowDirectTeamAdd = player.allowDirectTeamAdd!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: player.profileImageUrl != null
              ? CachedNetworkImageProvider(player.profileImageUrl!)
              : const AssetImage('assets/images/Default_user_pfp.jpg'),
          radius: 30,
        ),
        title: Text(player.name),
        subtitle: Text(player.cricketRole!.name),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PlayerProfileScreen(player: player),
        )),
        trailing: Consumer(
          builder: (context, ref, _) {
            final requestStatus = ref.watch(requestStatusProvider);
            final isRequestInProgress =
                requestStatus.requestInProgress.contains(player.id);
            final isRequestSuccess =
                requestStatus.requestSuccess.contains(player.id);

            final isAdded = teamsId.contains(_team.id) || isRequestSuccess;
            final buttonText = isAdded
                ? 'Added'
                : allowDirectTeamAdd
                    ? 'Add'
                    : 'Offer';
            final isButtonDisabled = isAdded || isRequestInProgress;

            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonDisabled ? Colors.grey : buttonBgColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                fixedSize: const Size(95, 35),
              ),
              onPressed: isButtonDisabled
                  ? null
                  : () => addPlayer(
                        player.id,
                        player.name,
                        player.cricketRole!.name,
                        player.profileImageUrl,
                      ),
              child: isRequestInProgress
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : Text(
                      buttonText,
                      style: const TextStyle(color: blackColor),
                    ),
            );
          },
        ),
      ),
    );
  }
}
