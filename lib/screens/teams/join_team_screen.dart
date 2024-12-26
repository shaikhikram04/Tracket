import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/models/team.dart';
import 'package:tracket/provider/team_provider.dart';
import 'package:tracket/resources/firebase_auth_methods.dart';
import 'package:tracket/screens/teams/team_profile_screen.dart';
import 'package:tracket/utils/colors.dart';

class JoinTeamScreen extends ConsumerWidget {
  const JoinTeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Team'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('teams').snapshots(),
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
              final teamData = Team.formSeed(snap[index].data());
              final isJoined = teamData.playersList.any(
                (player) => player['id'] == FirebaseAuthMethods.currentUserId,
              );
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: teamData.logoUrl == null
                      ? const AssetImage('assets/images/team_logo.png')
                      : NetworkImage(teamData.logoUrl!),
                  radius: 30,
                ),
                title: Text(teamData.name),
                subtitle: Text(teamData.shortName),
                onTap: () {
                  ref.read(teamProvider.notifier).updateTeam(teamData);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TeamProfileScreen(),
                  ));
                },
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isJoined ? Colors.grey : buttonBgColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                  onPressed: isJoined ? null : () {},
                  child: Text(
                    isJoined ? 'Joined' : 'Join',
                    style: const TextStyle(
                      color: blackColor,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
