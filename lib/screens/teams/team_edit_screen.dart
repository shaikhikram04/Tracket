import 'package:flutter/material.dart';
import 'package:tracket/screens/teams/add_player_screen.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/widgets/my_card.dart';
import 'package:tracket/widgets/my_dropdown_menu.dart';
import 'package:tracket/widgets/my_elevated_button.dart';
import 'package:tracket/widgets/my_text_field.dart';
import 'package:tracket/widgets/squad.dart';

class TeamEditScreen extends StatefulWidget {
  const TeamEditScreen({super.key});

  @override
  State<TeamEditScreen> createState() => _TeamEditScreenState();
}

class _TeamEditScreenState extends State<TeamEditScreen> {
  final playersList = [1, 2, 3, 4, 5];
  int currentTeamCapacity = 15;

  void addPlayer() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AddPlayerScreen(
        teamId: '',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Team'),
          actions: [
            IconButton(
              onPressed: addPlayer,
              icon: const Icon(Icons.save),
              iconSize: 30,
              color: darkGreenColor,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                MyCard(
                  child: Column(
                    spacing: 15,
                    children: [
                      Text(
                        'Primary Info',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 23),
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                AssetImage('assets/images/team_logo.png'),
                          ),
                          const SizedBox(width: 15),
                          TextButton.icon(
                            onPressed: () {},
                            label: Text(
                              'Edit team logo',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: blackColor,
                              backgroundColor: lightCardColor,
                              iconColor: blackColor,
                            ),
                            icon: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                      MyTextField(
                        onSave: (value) {},
                        label: 'Team Name',
                        borderRadius: 15,
                      ),
                      MyTextField(
                        onSave: (value) {},
                        label: 'Team Short Name',
                        borderRadius: 15,
                      ),
                      MyTextField(
                        onSave: (value) {},
                        label: 'Description',
                        borderRadius: 15,
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 5),
                          Text(
                            'Max Players Capacity:',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                currentTeamCapacity > 0
                                    ? currentTeamCapacity--
                                    : currentTeamCapacity;
                              });
                            },
                            icon: const Icon(Icons.remove_circle),
                            iconSize: 30,
                            color: darkGreenColor,
                          ),
                          Text(
                            '$currentTeamCapacity',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                currentTeamCapacity < 30
                                    ? currentTeamCapacity++
                                    : currentTeamCapacity;
                              });
                            },
                            icon: const Icon(Icons.add_circle),
                            iconSize: 30,
                            color: darkGreenColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                MyCard(
                    child: Squad(
                  playersList: playersList,
                  captainId: 'captainId',
                  wicketKeeperId: 'wicketKeeperId',
                  teamId: 'teamId',
                  isEdit: true,
                )),
                MyCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      Text(
                        'Roles',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 23),
                      ),
                      MyDropdownMenu(
                        options: const [],
                        label: 'Change captancy',
                        onSelect: (value) {},
                      ),
                      MyDropdownMenu(
                        options: const [],
                        label: 'Change Wicketkeeper',
                        onSelect: (value) {},
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: width * 0.9,
                  height: 50,
                  child: MyElevatedButton(
                    onPressed: () {},
                    text: 'Save Changes',
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }
}
