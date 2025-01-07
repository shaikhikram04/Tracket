import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/teams/screens/create_team_screen.dart';
import 'package:tracket/teams/screens/join_team_screen.dart';
import 'package:tracket/teams/screens/team_profile_screen.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_list_tile.dart';
import 'package:tracket/widgets/no_data_found.dart';

class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final playerTeamsId = player.playerTeamsId;
    playerTeamsId.add('');
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .where('id', whereIn: playerTeamsId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.size == 0) {
            return const NoDataFound(
              title: "No teams joined or created yet!",
              message: "Tap the button below to join or create a team.",
              isPointingButton: true,
              rotation: 1,
            );
          }

          final snap = snapshot.data!.docs;
          return ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (BuildContext context, int index) {
              final teamData = snap[index].data();

              final String logoUrl = teamData['logoUrl'];
              final String teamName = teamData['teamName'];
              final String shortName = teamData['shortName'];
              final String teamRole = player.teams!
                  .firstWhere((team) => team['id'] == teamData['id'])['role'];

              final isAdmin = teamRole != 'player';

              return MyListTile(
                title: teamName,
                subtitle: shortName,
                isPlayer: false,
                imageUrl: logoUrl,
                trailing: isAdmin ? Text(teamRole) : null,
                onTap: () async {
                  if (context.mounted) {
                    pushScreen(
                        context,
                        TeamProfileScreen(
                          teamData: teamData,
                          isAdmin: isAdmin,
                        ));
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        animatedIcon: AnimatedIcons.menu_close,
        overlayOpacity: 0.45,
        overlayColor: Colors.black,
        animationDuration: const Duration(milliseconds: 280),
        animationCurve: Curves.easeInOut,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.group_add),
            label: 'Join Team',
            onTap: () {
              pushScreen(context, JoinTeamScreen(player));
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.create),
            label: 'Create Team',
            onTap: () {
              pushScreen(context, const CreateTeamScreen());
            },
          ),
        ],
      ),
    );
  }
}
