import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/teams/screens/team_profile_screen.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_list_tile.dart';
import 'package:tracket/widgets/no_data_found.dart';

class ExploreTeams extends StatelessWidget {
  const ExploreTeams({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Teams'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .orderBy('followers', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData || snapshot.data!.size == 0) {
            return const NoDataFound(
              title: 'No team created yet',
              message: 'Wait for team creation to explore',
            );
          }

          final snap = snapshot.data!.docs;

          return ListView.builder(
            itemCount: snap.length,
            itemBuilder: (BuildContext context, int index) {
              final teamSnap = snap[index].data();

              return MyListTile(
                  imageUrl: teamSnap['logoUrl'],
                  title: teamSnap['name'],
                  subtitle: teamSnap['shortName'],
                  trailing: null,
                  onTap: () => pushScreen(context,
                      TeamProfileScreen(teamData: teamSnap)),
                  isPlayer: false);
            },
          );
        },
      ),
    );
  }
}
