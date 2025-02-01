import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/players/services/players_services.dart';
import 'package:tracket/notifications/screens/manage_requests_screen.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/teams/models/team_role.dart';
import 'package:tracket/teams/providers/request_status_provider.dart';
import 'package:tracket/teams/providers/team_provider.dart';
import 'package:tracket/teams/screens/add_admin.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/teams/widgets/privacy_settings.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';

class TeamSettingsScreen extends ConsumerWidget {
  const TeamSettingsScreen({super.key});

  ListTile getRequestTile(
      BuildContext context, String request, int count, void Function() onTap) {
    return ListTile(
      onTap: onTap,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: request,
              style: MyTextStyle(context).bodyLarge,
            ),
            // TextSpan(
            //   text: ' ($count)',
            //   style: Theme.of(context).textTheme.bodyLarge,
            // ),
          ],
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamProvider);

    void onDeleteTeam() {
      showAlertDoubleBtnDialog(
        context,
        title: 'Delete Team',
        content:
            'Are you sure you want to delete this team? This action cannot be undone.',
        sureButtonText: 'Delete',
        onSureButtonPressed: () {
          TeamsServices.deleteTeam(context, team.id);
        },
      );
    }

    void removeAdmin(String playerId) {
      showAlertDoubleBtnDialog(
        context,
        title: 'Remove Admin',
        content: 'Are you sure you want to remove this admin?',
        sureButtonText: 'Remove',
        onSureButtonPressed: () {
          PlayersServices.changePlayerTeamRole(
              playerId: playerId,
              teamId: team.id,
              newRole: TeamRole.player,
              ref: ref,
              context: context);
        },
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
                        onPressed: () {
                          ref
                              .read(requestStatusProvider.notifier)
                              .setRequestStatus();
                          pushScreen(context, AddAdmin(team: team));
                        },
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
                              pushScreen(context,
                                  PlayerProfileScreen(playerId: admin.id));
                            },
                            leading: getCircleAvatar(
                                url: admin.imageUrl, isTeam: false, radius: 25),
                            title: Text(admin.name),
                            subtitle: Text(admin.role.toString()),
                            trailing: admin.role == TeamRole.owner
                                ? null
                                : MyElevatedButton.secondaryElevatedButton(
                                    context,
                                    text: 'Remove',
                                    onPressed: () => removeAdmin(admin.id),
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
                    context,
                    'Recieved Requests',
                    team.pendingRequest,
                    () {
                      pushScreen(
                          context, ManageRequestsScreen(teamId: team.id));
                    },
                  ),
                  getRequestTile(
                    context,
                    'Sent Requests',
                    team.sendRequest,
                    () {
                      pushScreen(
                          context,
                          ManageRequestsScreen(
                              teamId: team.id, initialIndex: 1));
                    },
                  ),
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
                await TeamsServices.updateTeamPrivacy(
                  context,
                  teamId: team.id,
                  isPrivate: newValue,
                );
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
                    style: MyTextStyle(context).coloredTitleLarge(Colors.red),
                  ),
                  const Spacer(),
                  MyElevatedButton.secondaryElevatedButton(
                    context,
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
