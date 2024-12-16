import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class AddPlayerScreen extends StatefulWidget {
  const AddPlayerScreen({super.key});

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
            .collection('users')
            .where('role', isEqualTo: 'player')
            .snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/Default_user_pfp.jpg'),
                  radius: 30,
                ),
                title: const Text('Player Name'),
                subtitle: const Text('Cricket Role'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBgColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Offer',
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
