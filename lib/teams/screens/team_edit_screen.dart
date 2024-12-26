import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/providers/team_provider.dart';
import 'package:tracket/teams/screens/add_player_screen.dart';
import 'package:tracket/teams/widgets/player_capacity_selector.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';
import 'package:tracket/widgets/custom_widgets/my_dropdown_menu.dart';
import 'package:tracket/widgets/custom_widgets/my_elevated_button.dart';
import 'package:tracket/widgets/custom_widgets/my_text_field.dart';
import 'package:tracket/widgets/squad.dart';
import 'package:tracket/widgets/team_logo_editor.dart';

class TeamEditScreen extends ConsumerStatefulWidget {
  const TeamEditScreen({super.key});

  @override
  ConsumerState<TeamEditScreen> createState() => _TeamEditScreenState();
}

class _TeamEditScreenState extends ConsumerState<TeamEditScreen> {
  late final Team _team;
  Uint8List? _image;
  late List _playersList;
  List<String> _playerNames = [];
  late int _maxPlayersCapacity;

  @override
  void initState() {
    _team = ref.read(teamProvider);
    _playersList = _team.playersList;
    _maxPlayersCapacity = _team.maxPlayersCapacity;

    _playerNames =
        _playersList.map((player) => player['name'].toString()).toList();
    super.initState();
  }

  void addPlayer() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddPlayerScreen(
        teamId: _team.id,
      ),
    ));
  }

  Future<void> _editLogo(Uint8List? image) async {
    try {
      final pickedImage = await pickImage(ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = pickedImage;
        });
      }
    } catch (e) {
      if (!mounted) return;
      showSnackBar('Failed to pick an image: $e', context);
    }
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
                      TeamLogoEditor(
                        logoUrl: _team.logoUrl,
                        image: _image,
                        onImageChanged: _editLogo,
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
                      PlayerCapacitySelector(
                        maxPlayersCapacity: _maxPlayersCapacity,
                        onIncrement: () => setState(
                          () => _maxPlayersCapacity++,
                        ),
                        onDecrement: () => setState(
                          () => _maxPlayersCapacity--,
                        ),
                      )
                    ],
                  ),
                ),

                //! Squad
                const MyCard(
                  child: Squad(
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
