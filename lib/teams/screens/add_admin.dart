import 'package:flutter/material.dart';
import 'package:tracket/players/widgets/player_list_view.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/widgets/no_data_found.dart';

class AddAdmin extends StatelessWidget {
  const AddAdmin({super.key, required this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Admin'),
        elevation: 0,
      ),
      body: PlayerListView(
        players: team.nonAdmins,
        team: team,
        emptyStateWidget: const NoDataFound(
          title: 'No player found to add ad admin',
          message: 'All players are already admin',
        ),
      ),
    );
  }
}
