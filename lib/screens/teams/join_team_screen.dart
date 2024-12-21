import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracket/models/team.dart';
import 'package:tracket/screens/teams/team_details_screen.dart';
import 'package:tracket/utils/colors.dart';

class JoinTeamScreen extends StatelessWidget {
  const JoinTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                (player) =>
                    player['id'] == FirebaseAuth.instance.currentUser!.uid,
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
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TeamDetailsScreen(teamData: teamData),
                )),
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
