import 'package:flutter/material.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/teams/models/team_role.dart';
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
                final playerInfo = nonAdminPlayers[index];
                final teamInfo = TeamDetails(
                  id: team.id,
                  logoUrl: team.logoUrl,
                  name: team.name,
                  shortName: team.shortName,
                  role: TeamRole.player,
                );
                return MyListTile(
                  imageUrl: playerInfo.imageUrl,
                  title: playerInfo.name,
                  subtitle: playerInfo.cricketRole.name,
                  onTap: () => pushScreen(
                      context, PlayerProfileScreen(playerId: playerInfo.id)),
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
