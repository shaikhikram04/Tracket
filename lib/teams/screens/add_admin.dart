import 'package:flutter/material.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_consumer.dart';
import 'package:tracket/widgets/custom_widgets/my_list_tile.dart';
import 'package:tracket/widgets/no_data_found.dart';

class AddAdmin extends StatelessWidget {
  const AddAdmin({super.key, required this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    final nonAdminPlayers = team.nonAdmins;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Admin'),
      ),
      body: nonAdminPlayers.isNotEmpty
          ? ListView.builder(
              itemCount: nonAdminPlayers.length,
              itemBuilder: (context, index) {
                final player = nonAdminPlayers[index];
                final playerInfo = {'id': player['id']};
                final teamInfo = {'id': team.id};
                return MyListTile(
                  imageUrl: player['imageUrl'],
                  title: player['name'],
                  subtitle: player['cricketRole'],
                  onTap: () => pushScreen(
                      context, PlayerProfileScreen(playerId: player['id'])),
                  isPlayer: true,
                  trailing: MyConsumer(
                      idsList: const [],
                      isPrivate: false,
                      buttonType: 'addAdmin',
                      playerInfo: playerInfo,
                      teamInfo: teamInfo),
                );
              },
            )
          : const NoDataFound(
              title: 'No player found to add ad admin',
              message: 'All players are already admin'),
    );
  }
}
