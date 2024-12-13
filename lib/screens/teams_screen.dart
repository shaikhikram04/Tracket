import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tracket/screens/create_team_screen.dart';

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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.group_off,
                        size: 100,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "No teams joined or created yet!",
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Tap the button below to join or create a team.",
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      ZoomIn(
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            Icons.arrow_outward,
                            size: 50,
                            color: Colors.green.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateTeamScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
