import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/providers/team_provider.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/teams/widgets/player_capacity_selector.dart';
import 'package:tracket/teams/widgets/squad.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/validation_services.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';
import 'package:tracket/widgets/custom_widgets/my_dropdown_menu.dart';
import 'package:tracket/widgets/custom_widgets/my_text_field.dart';
import 'package:tracket/widgets/team_logo_editor.dart';

class TeamEditScreen extends ConsumerStatefulWidget {
  const TeamEditScreen({super.key});

  @override
  ConsumerState<TeamEditScreen> createState() => _TeamEditScreenState();
}

class _TeamEditScreenState extends ConsumerState<TeamEditScreen> {
  late Team _team;
  Uint8List? _image;
  final _formKey = GlobalKey<FormState>();
  late int _maxPlayersCapacity;
  String? _teamName;
  String? _teamShortName;
  String? _teamDescription;
  String? _captain;
  String? _wicketkeeper;
  bool _isSaving = false;

  @override
  void initState() {
    _team = ref.read(teamProvider);
    _maxPlayersCapacity = _team.maxPlayersCapacity;
    super.initState();
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

  List<String> get _playerNames {
    _captain = null;
    _wicketkeeper = null;
    List<String> playerNames = [];
    for (var player in _team.playersList) {
      playerNames.add(player.name);
      if (player.id == _team.captainId) {
        _captain = player.name;
      }
      if (player.id == _team.wicketkeeperId) {
        _wicketkeeper = player.name;
      }
    }

    return playerNames;
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() {
      _isSaving = true;
    });
    final teamPlayers = _team.playersList;

    String? captainId;
    if (_captain != null) {
      int index = teamPlayers.indexWhere(
        (player) => player.name == _captain,
      );
      captainId = teamPlayers[index].id;
    }

    String? wicketkeeperId;
    if (_wicketkeeper != null) {
      int index = teamPlayers.indexWhere(
        (player) => player.name == _wicketkeeper,
      );
      wicketkeeperId = teamPlayers[index].id;
    }

    String? logoUrl;

    if (_image != null) {
      //! Upload image to Firebase Storage
    }
    try {
      await TeamsServices.updateTeamField(
        context,
        teamId: _team.id,
        teamName: _teamName,
        shortName: _teamShortName,
        description: _teamDescription,
        maxPlayersCapacity: _maxPlayersCapacity,
        captainId: captainId,
        wicketkeeperId: wicketkeeperId,
        logoUrl: logoUrl,
      );

      ref.read(teamProvider.notifier).updateField(
            name: _teamName!,
            shortName: _teamShortName,
            description: _teamDescription,
            maxPlayersCapacity: _maxPlayersCapacity,
            captainId: captainId,
            wicketkeeperId: wicketkeeperId,
          );

      if (mounted) {
        showSnackBar('Team updated successfully!', context);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;
      showSnackBar('Failed to update Team! : $e', context);
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _team = ref.watch(teamProvider);
    final width = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        _formKey.currentState!.save();

        final teamPlayers = _team.playersList;

        String captainId = '';
        if (_captain != null) {
          int index = teamPlayers.indexWhere(
            (player) => player.name == _captain,
          );
          captainId = teamPlayers[index].id;
        }

        String wicketkeeperId = '';
        if (_wicketkeeper != null) {
          int index = teamPlayers.indexWhere(
            (player) => player.name == _wicketkeeper,
          );
          wicketkeeperId = teamPlayers[index].id;
        }

        if (_teamName != _team.name ||
            _teamShortName != _team.shortName ||
            _teamDescription != _team.description ||
            _maxPlayersCapacity != _team.maxPlayersCapacity ||
            captainId != _team.captainId ||
            wicketkeeperId != _team.wicketkeeperId ||
            _image != null) {
          showAlertDoubleBtnDialog(
            context,
            title: 'Discard Changes?',
            content: 'Are you sure you want to discard the changes?',
            sureButtonText: 'Discard',
            onSureButtonPressed: () {
              Navigator.of(context).pop();
            },
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Edit Team'),
            shadowColor: blackColor,
            actions: [
              _isSaving
                  ? getCircleLoadingIndicator(dimension: 20)
                  : IconButton(
                      onPressed: _saveChanges,
                      icon: const Icon(Icons.save),
                      iconSize: 30,
                      color: darkGreenColor,
                    ),
              SizedBox(width: _isSaving ? 20 : 10),
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  //! Primary Info
                  MyCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        spacing: 15,
                        children: [
                          getTitleText('Primary Info', context),
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
                              _teamName = value;
                            },
                            label: 'Team Name',
                            borderRadius: 15,
                            validator: (value) =>
                                ValidationServices.nameValidator(
                                    value, 'Team Name'),
                          ),
                          MyTextField(
                            initialText: _team.shortName,
                            onSave: (value) {
                              _teamShortName = value;
                            },
                            label: 'Team Short Name',
                            borderRadius: 15,
                            validator:
                                ValidationServices.teamShortNameValidator,
                          ),
                          MyTextField(
                            initialText: _team.description,
                            onSave: (value) {
                              _teamDescription = value;
                            },
                            label: 'Description',
                            borderRadius: 15,
                            maxLength: 100,
                            maxLines: 3,
                            minLines: 2,
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
                  ),

                  //! Squad
                  const MyCard(child: Squad(isEdit: true)),
                  //! Roles
                  MyCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 12,
                      children: [
                        getTitleText('Roles', context),
                        //! Captain, Wicketkeeper
                        MyDropdownMenu(
                          options: _playerNames,
                          label: 'Change captancy',
                          initialSelection: _captain,
                          onSelect: (value) {
                            _captain = value;
                          },
                        ),
                        MyDropdownMenu(
                          options: _playerNames,
                          label: 'Change Wicketkeeper',
                          initialSelection: _wicketkeeper,
                          onSelect: (value) {
                            _wicketkeeper = value;
                          },
                        )
                      ],
                    ),
                  ),
                  //! Save Changes
                  SizedBox(
                    width: width * 0.9,
                    height: 50,
                    child: MyElevatedButton.primaryElevatedButton(
                      context,
                      onPressed: _saveChanges,
                      text: 'Save Changes',
                      isSubmit: true,
                      isLoading: _isSaving,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          )),
    );
  }
}
