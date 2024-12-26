import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/models/team.dart';
import 'package:tracket/provider/team_provider.dart';
import 'package:tracket/screens/teams/add_player_screen.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/my_card.dart';
import 'package:tracket/widgets/my_dropdown_menu.dart';
import 'package:tracket/widgets/my_elevated_button.dart';
import 'package:tracket/widgets/my_text_field.dart';
import 'package:tracket/widgets/squad.dart';

class TeamEditScreen extends ConsumerStatefulWidget {
  const TeamEditScreen({super.key});

  @override
  ConsumerState<TeamEditScreen> createState() => _TeamEditScreenState();
}

class _TeamEditScreenState extends ConsumerState<TeamEditScreen> {
  late final Team _team;
  late List _playersList;
  Uint8List? _image;

  List<String> _playerNames = [];

  @override
  void initState() {
    _team = ref.watch(teamProvider);
    _playersList = _team.playersList;

    _playerNames =
        _playersList.map((player) => player['name'].toString()).toList();
    super.initState();
  }

  Future<void> _editLogo() async {
    final pickedImage = await pickImage(ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  void addPlayer() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddPlayerScreen(
        teamId: _team.id,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Team'),
          shadowColor: blackColor,
          actions: [
            IconButton(
              onPressed: () {},
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
                //! Primary Info
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
                      //! Team Logo
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            backgroundImage: _image != null
                                ? MemoryImage(_image!)
                                : const AssetImage(
                                    'assets/images/team_logo.png'),
                          ),
                          const SizedBox(width: 15),
                          TextButton.icon(
                            onPressed: _editLogo,
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
                      //! Team Name, Short Name, Description
                      MyTextField(
                        initialText: _team.name,
                        onSave: (value) {
                          ref
                              .read(teamProvider.notifier)
                              .updateField(name: value);
                        },
                        label: 'Team Name',
                        borderRadius: 15,
                      ),
                      MyTextField(
                        initialText: _team.shortName,
                        onSave: (value) {
                          ref
                              .read(teamProvider.notifier)
                              .updateField(shortName: value);
                        },
                        label: 'Team Short Name',
                        borderRadius: 15,
                      ),
                      MyTextField(
                        initialText: _team.description,
                        onSave: (value) {
                          ref
                              .read(teamProvider.notifier)
                              .updateField(description: value);
                        },
                        label: 'Description',
                        borderRadius: 15,
                        maxLength: 100,
                      ),
                      //! Team Player Capacity
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
                              if (_team.maxPlayersCapacity > 0) {
                                ref
                                    .read(teamProvider.notifier)
                                    .decrementCapacity();
                              }
                            },
                            icon: const Icon(Icons.remove_circle),
                            iconSize: 30,
                            color: darkGreenColor,
                          ),
                          Text(
                            '${_team.maxPlayersCapacity}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          IconButton(
                            onPressed: () {
                              if (_team.maxPlayersCapacity < 30) {
                                ref
                                    .read(teamProvider.notifier)
                                    .incrementCapacity();
                              }
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

                //! Squad
                MyCard(
                  child: Squad(
                    playersList: _playersList,
                    captainId: _team.captainId,
                    wicketKeeperId: _team.wicketKeeperId,
                    teamId: _team.id,
                    isEdit: true,
                  ),
                ),
                //! Roles
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
                      //! Captain, Wicketkeeper
                      MyDropdownMenu(
                        options: _playerNames,
                        label: 'Change captancy',
                        onSelect: (value) {},
                      ),
                      MyDropdownMenu(
                        options: _playerNames,
                        label: 'Change Wicketkeeper',
                        onSelect: (value) {},
                      )
                    ],
                  ),
                ),
                //! Save Changes
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
