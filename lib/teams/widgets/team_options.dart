import 'package:flutter/material.dart';
import 'package:tracket/teams/screens/team_edit_screen.dart';
import 'package:tracket/teams/screens/team_settings_screen.dart';
import 'package:tracket/utils/utils.dart';

class TeamOptions extends StatelessWidget {
  const TeamOptions({super.key, required this.isOwner});

  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Team Options',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: const Text('Edit Team Details'),
            onTap: () {
              Navigator.of(context).pop(); // Close the modal
              pushScreen(context, const TeamEditScreen());
            },
          ),
          if (isOwner)
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.green),
              title: const Text('Team Settings'),
              onTap: () {
                Navigator.of(context).pop(); // Close the modal
                pushScreen(context, const TeamSettingsScreen());
              },
            ),
          ListTile(
            leading: const Icon(Icons.cancel, color: Colors.red),
            title: const Text('Cancel'),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
