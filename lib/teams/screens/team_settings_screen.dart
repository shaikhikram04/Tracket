import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/resources/firestore_methods.dart';
import 'package:tracket/teams/providers/team_provider.dart';
import 'package:tracket/teams/widgets/privacy_settings.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';

class TeamSettingsScreen extends ConsumerWidget {
  const TeamSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamProvider);
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

    ListTile getRequestTile(String request, int count, void Function() onTap) {
      return ListTile(
        onTap: onTap,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: request,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextSpan(
                text: ' ($count)',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            //! Admins Section
            MyCard(
              child: Column(
                children: [
                  //! Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getTitleText('Manage Admins', context),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.person_add),
                        iconSize: 30,
                        color: darkGreenColor,
                      )
                    ],
                  ),
                  //! Admins List
                  Column(
                    children: [
                      for (final admin in team.admins)
                        ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 2,
                            ),
                            onTap: () {
                              pushScreen(
                                  context,
                                  PlayerProfileScreen(
                                      playerId: admin['playerId']));
                            },
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: admin['imageUrl'] != null
                                  ? NetworkImage(admin['imageUrl'])
                                  : const AssetImage(
                                      'assets/images/Default_user_pfp.jpg'),
                            ),
                            title: Text(admin['name']),
                            subtitle: Text(admin['playerId'] == team.createdBy
                                ? 'Owner'
                                : 'Admin'),
                            trailing: buildElevatedButton(
                              text: 'Remove',
                              onPressed: removeAdmin,
                            )),
                    ],
                  ),
                ],
              ),
            ),
            //! Requests Section
            MyCard(
              child: Column(
                children: [
                  //! Title Row
                  getTitleText('Player Request', context),
                  const SizedBox(height: 10),
                  getRequestTile(
                      'Pending Requests', team.pendingRequest, () {}),
                  getRequestTile('Sent Requests', team.sendRequest, () {}),
                ],
              ),
            ),
            //! Privacy Settings
            PrivacySettings(
              isTeamPrivate: team.isPrivate,
              onSwitchChanged: (newValue) async {
                if (newValue) {
                  showSnackBar('Now no one can add directly in team', context);
                } else {
                  showSnackBar('Now anyone can add directly in team', context);
                }
                await FirestoreMethods.updateTeamPrivacy(
                    teamId: team.id, isPrivate: newValue);
                ref
                    .read(teamProvider.notifier)
                    .updateField(isTeamPrivate: newValue);
              },
            ),
            //! Delete Team
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
