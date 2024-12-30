import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';

class TeamSettingsScreen extends StatelessWidget {
  const TeamSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ElevatedButton buildElevatedButton(
        {required String text, required Function() onPressed}) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Colors.red, width: 1),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
        ),
      );
    }

    void showingAlertDialog(
        {required String title,
        required String content,
        required String sureButtonText,
        required Function() onSureButtonPressed}) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onSureButtonPressed();
                },
                child: Text(
                  sureButtonText,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }

    void onDeleteTeam() {
      showingAlertDialog(
        title: 'Delete Team',
        content:
            'Are you sure you want to delete this team? This action cannot be undone.',
        sureButtonText: 'Delete',
        onSureButtonPressed: () {},
      );
    }

    void removeAdmin() {
      showingAlertDialog(
        title: 'Remove Admin',
        content: 'Are you sure you want to remove this admin?',
        sureButtonText: 'Remove',
        onSureButtonPressed: () {},
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Settings'),
      ),
      body: Column(
        children: [
          MyCard(
            child: Column(
              children: [
                //! Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Manage Admins',
                        style: Theme.of(context).textTheme.titleLarge),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add),
                      iconSize: 30,
                      color: darkGreenColor,
                    )
                  ],
                ),
                //! Admins List
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 2,
                        ),
                        onTap: () {},
                        leading: const CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              AssetImage('assets/images/Default_user_pfp.jpg'),
                        ),
                        title: const Text('Admin Name'),
                        subtitle: const Text('Admin/owner'),
                        trailing: buildElevatedButton(
                          text: 'Remove',
                          onPressed: removeAdmin,
                        ));
                  },
                )
              ],
            ),
          ),
          MyCard(
            child: Column(
              children: [
                //! Title Row
                Text('Player Requests',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                ListTile(
                  onTap: () {},
                  title: Text(
                    'Pending Requests (3)',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {},
                  title: Text(
                    'Sent Requests (2)',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
          MyCard(
            child: Row(
              spacing: 16,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Delete Team',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.red,
                      ),
                ),
                const Spacer(),
                buildElevatedButton(
                  text: 'Delete',
                  onPressed: onDeleteTeam,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
