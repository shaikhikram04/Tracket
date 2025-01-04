import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/resources/firestore_collections.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/screens/team_profile_screen.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_consumer.dart';

class JoinTeamScreen extends StatelessWidget {
  const JoinTeamScreen(this.player, {super.key});

  final Player player;

  List<String> get playerTeamsId =>
      player.teams!.map((e) => e['id'].toString()).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Team'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.size == 0) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'No teams available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please check back later or create a new team.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
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
    Map<String, dynamic> teamInfo = {
      'id': team.id,
      'name': team.name,
      'shortName': team.shortName,
      'logoUrl': team.logoUrl,
      'role': 'player',
    };
    Map<String, dynamic> playerInfo = {
      'id': player.id,
      'name': player.name,
      'cricketRole': player.cricketRole!.name,
      'imageUrl': player.profileImageUrl,
      'role': 'player',
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: team.logoUrl.isNotEmpty
              ? CachedNetworkImageProvider(team.logoUrl)
              : const AssetImage('assets/images/team_logo.png'),
          radius: 30,
        ),
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
