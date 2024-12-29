import 'package:flutter/material.dart';
import 'package:tracket/teams/screens/team_edit_screen.dart';

class TeamOptions extends StatelessWidget {
  const TeamOptions({super.key});

  void _navigateToTeamSettings(BuildContext context) {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => const TeamSettingsScreen(),
    //   ),
    // );
  }

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
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TeamEditScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.green),
            title: const Text('Team Settings'),
            onTap: () {
              Navigator.of(context).pop(); // Close the modal
              _navigateToTeamSettings(context);
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
