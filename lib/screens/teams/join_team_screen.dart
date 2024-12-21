import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/team_logo.png'),
                  radius: 30,
                ),
                title: const Text('Team Name'),
                subtitle: const Text('Team Short Name'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBgColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Join',
                    style: TextStyle(
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
