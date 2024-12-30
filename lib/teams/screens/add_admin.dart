import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/utils/colors.dart';

class AddAdmin extends ConsumerWidget {
  const AddAdmin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Admin'),
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/Default_user_pfp.jpg'),
            ),
            title: const Text('Player name'),
            subtitle: const Text('Cricket Role'),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBgColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              onPressed: () {},
              child: const Text(
                'Add',
                style: TextStyle(color: blackColor),
              ),
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
