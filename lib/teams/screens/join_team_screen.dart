import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/teams/screens/team_profile_screen.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_consumer.dart';
import 'package:tracket/widgets/no_data_found.dart';

class JoinTeamScreen extends StatelessWidget {
  const JoinTeamScreen(this.player, {super.key});

  final Player player;

  List<String> get playerTeamsId =>
      player.playerCricketDetails!.teams.map((team) => team.id).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Team'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .where('id', whereNotIn: player.playerTeamsId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return getCircleLoadingIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.size == 0) {
            return const Center(
                child: NoDataFound(
                    title: 'No Teams available to join',
                    message: 'Please check back later or create a new team.'));
          }

          final snap = snapshot.data!.docs;
          return ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              return buildTeamTile(snap[index].data(), context);
            },
          );
        },
      ),
    );
  }

  Widget buildTeamTile(Map<String, dynamic> teamData, BuildContext context) {
    final team = Team.formSeed(teamData, null);
    final teamInfo = TeamDetails(
      id: team.id,
      logoUrl: team.logoUrl,
      name: team.name,
      shortName: team.shortName,
      role: TeamRole.player,
    );
    final playerInfo = PlayerDetails(
      cricketRole: player.playerCricketDetails!.cricketRole,
      id: player.id,
      imageUrl: player.profileImageUrl,
      name: player.name,
      role: TeamRole.player,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: getCircleAvatar(url: team.logoUrl, isTeam: true, radius: 30),
        title: Text(team.name),
        subtitle: Text(team.shortName),
        onTap: () => pushScreen(context, TeamProfileScreen(teamData: teamData)),
        trailing: MyConsumer(
          idsList: playerTeamsId,
          isPrivate: team.isPrivate,
          buttonType: 'joinTeam',
          teamInfo: teamInfo,
          playerInfo: playerInfo,
          isTeamFull: team.playerIds.length >= team.maxPlayersCapacity,
        ),
      ),
    );
  }
}
