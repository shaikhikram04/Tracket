import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/screens/players/player_profile_screen.dart';
import 'package:tracket/utils/colors.dart';

class AddPlayerScreen extends StatefulWidget {
  const AddPlayerScreen({super.key, required this.teamId});
  final String teamId;

  @override
  State<AddPlayerScreen> createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Player'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('players')
            .where('role', isEqualTo: 'player')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Players Found'),
            );
          }
          final snap = snapshot.data!.docs;
          return ListView.builder(
            itemCount: snap.length,
            itemBuilder: (context, index) {
              final playerData = snap[index].data();
              final List teamsId = playerData['teamsId'];
              final isAdded = teamsId.contains(widget.teamId);
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: playerData['profileImageUrl'] != null
                      ? NetworkImage(playerData['profileImageUrl'])
                      : const AssetImage('assets/images/Default_user_pfp.jpg'),
                  radius: 30,
                ),
                title: Text(playerData['playerName']),
                subtitle: Text(playerData['cricketRole']),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PlayerProfileScreen(),
                )),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAdded ? Colors.grey : buttonBgColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                  onPressed: isAdded ? null : () {},
                  child: Text(
                    isAdded ? 'Added' : 'Offer',
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
