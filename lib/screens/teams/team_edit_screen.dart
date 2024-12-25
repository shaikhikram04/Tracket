import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/models/team.dart';
import 'package:tracket/screens/teams/add_player_screen.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/my_card.dart';
import 'package:tracket/widgets/my_dropdown_menu.dart';
import 'package:tracket/widgets/my_elevated_button.dart';
import 'package:tracket/widgets/my_text_field.dart';
import 'package:tracket/widgets/squad.dart';

class TeamEditScreen extends StatefulWidget {
  const TeamEditScreen({super.key, required this.teamData});

  final Team teamData;

  @override
  State<TeamEditScreen> createState() => _TeamEditScreenState();
}

class _TeamEditScreenState extends State<TeamEditScreen> {
  late final Team _teamInfo;
  late List _playersList;
  late int _currentTeamCapacity;
  late String? _teamName;
  late String? _teamShortName;
  late String? _description;
  Uint8List? _image;

  List<String> _playerNames = [];

  @override
  void initState() {
    _teamInfo = widget.teamData;
    _playersList = _teamInfo.playersList;
    _currentTeamCapacity = _teamInfo.maxPlayersCapacity;
    _teamName = _teamInfo.name;
    _teamShortName = _teamInfo.shortName;
    _description = _teamInfo.description;
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
        teamId: _teamInfo.id,
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
                        initialText: _teamName,
                        onSave: (value) {
                          setState(() {
                            _teamName = value;
                          });
                        },
                        label: 'Team Name',
                        borderRadius: 15,
                      ),
                      MyTextField(
                        initialText: _teamShortName,
                        onSave: (value) {
                          setState(() {
                            _teamShortName = value;
                          });
                        },
                        label: 'Team Short Name',
                        borderRadius: 15,
                      ),
                      MyTextField(
                        initialText: _description,
                        onSave: (value) {
                          setState(() {
                            _description = value;
                          });
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
                              setState(() {
                                _currentTeamCapacity > 0
                                    ? _currentTeamCapacity--
                                    : _currentTeamCapacity;
                              });
                            },
                            icon: const Icon(Icons.remove_circle),
                            iconSize: 30,
                            color: darkGreenColor,
                          ),
                          Text(
                            '$_currentTeamCapacity',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _currentTeamCapacity < 30
                                    ? _currentTeamCapacity++
                                    : _currentTeamCapacity;
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

                //! Squad
                MyCard(
                  child: Squad(
                    playersList: _playersList,
                    captainId: _teamInfo.captainId,
                    wicketKeeperId: _teamInfo.wicketKeeperId,
                    teamId: _teamInfo.id,
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
