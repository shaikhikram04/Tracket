import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/teams/models/team_role.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_consumer.dart';
import 'package:tracket/widgets/custom_widgets/my_list_tile.dart';
import 'package:tracket/widgets/no_data_found.dart';

class AddPlayerScreen extends StatelessWidget {
  const AddPlayerScreen({super.key, required this.team});

  final Team team;

  List<String> get playersId =>
      team.playersList.map((player) => player.id).toList();

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
            return getCircleLoadingIndicator();
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong. Please try again later.'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const NoDataFound(
                title: 'No player found', message: 'Wait for players to join');
          }
          final snap = snapshot.data!.docs;
          return ListView.builder(
            itemCount: snap.length,
            itemBuilder: (context, index) {
              final player = Player.fromSeed(snap[index].data(), null);
              return buildPlayerTile(player, context);
            },
          );
        },
      ),
    );
  }

  Widget buildPlayerTile(Player player, BuildContext context) {
    final bool isPrivate = player.playerCricketDetails!.isPrivate;
    final playerInfo = PlayerDetails(
      cricketRole: player.playerCricketDetails!.cricketRole,
      id: player.id,
      imageUrl: player.profileImageUrl,
      name: player.name,
      role: TeamRole.player,
    );

    final teamInfo = TeamDetails(
      id: team.id,
      logoUrl: team.logoUrl,
      name: team.name,
      shortName: team.shortName,
      role: TeamRole.player,
    );

    final bool isTeamFull = team.playersList.length >= team.maxPlayersCapacity;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: MyListTile(
        imageUrl: player.profileImageUrl,
        title: player.name,
        subtitle: player.playerCricketDetails!.cricketRole.name,
        onTap: () => pushScreen(context, PlayerProfileScreen(player: player)),
        isPlayer: true,
        trailing: MyConsumer(
          idsList: playersId,
          isPrivate: isPrivate,
          buttonType: 'addPlayer',
          playerInfo: playerInfo,
          teamInfo: teamInfo,
          isTeamFull: isTeamFull,
        ),
      ),
    );
  }
}
