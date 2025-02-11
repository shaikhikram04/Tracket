import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/teams/providers/providers.dart';
import 'package:tracket/teams/providers/team_state.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/teams/widgets/capacity_selector.dart';
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
  late TeamState _teamState;
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
    _teamState = ref.read(teamProvider);
    _maxPlayersCapacity = _teamState.team.maxPlayersCapacity;
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
    for (var player in _teamState.team.playersList) {
      playerNames.add(player.name);
      if (player.id == _teamState.team.captainId) {
        _captain = player.name;
      }
      if (player.id == _teamState.team.wicketkeeperId) {
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
    final teamPlayers = _teamState.team.playersList;

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
        teamId: _teamState.team.id,
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
    _teamState = ref.watch(teamProvider);
    final width = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        _formKey.currentState!.save();

        final teamPlayers = _teamState.team.playersList;

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

        if (_teamName != _teamState.team.name ||
            _teamShortName != _teamState.team.shortName ||
            _teamDescription != _teamState.team.description ||
            _maxPlayersCapacity != _teamState.team.maxPlayersCapacity ||
            captainId != _teamState.team.captainId ||
            wicketkeeperId != _teamState.team.wicketkeeperId ||
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
                            logoUrl: _teamState.team.logoUrl,
                            image: _image,
                            onImageChanged: _editLogo,
                          ),
                          //! Team Name, Short Name, Description
                          MyTextField(
                            initialText: _teamState.team.name,
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
                            initialText: _teamState.team.shortName,
                            onSave: (value) {
                              _teamShortName = value;
                            },
                            label: 'Team Short Name',
                            borderRadius: 15,
                            validator:
                                ValidationServices.teamShortNameValidator,
                          ),
                          MyTextField(
                            initialText: _teamState.team.description,
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
                          CapacitySelector(
                              maxPlayersCapacity: _maxPlayersCapacity,
                              onIncrement: () {
                                if (_maxPlayersCapacity < 30) {
                                  setState(
                                    () => _maxPlayersCapacity++,
                                  );
                                } else {
                                  showSnackBar(
                                      'Max players capacity cannot exceed 30',
                                      context);
                                }
                              },
                              onDecrement: () {
                                if (_maxPlayersCapacity > 11) {
                                  setState(
                                    () => _maxPlayersCapacity--,
                                  );
                                } else {
                                  showSnackBar(
                                      'Max players capacity cannot be less than 11',
                                      context);
                                }
                              },
                              label: 'Max Players Capacity'),
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
                      onPressed: _saveChanges,
                      text: 'Save Changes',
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
