import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class TeamsList extends StatelessWidget {
  const TeamsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('teams').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.size == 0) {
            return const Center(
              child: Text('No Team created yet!'),
            );
          }
          return ListView.builder(
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return const ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/team_logo.png'),
                  radius: 30,
                ),
                title: Text('Team Name'),
                subtitle: Text('Team Short Name'),
                trailing: Text('Role in team'),
              );
            },
          );
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.group_add),
            label: 'Join Team',
            onTap: () {
              // Navigate to Join Team Screen
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.create),
            label: 'Create Team',
            onTap: () {
              // Navigate to Create Team Screen
            },
          ),
        ],
      ),
    );
  }
}
