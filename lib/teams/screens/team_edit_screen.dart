import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/supabase_services.dart';
import 'package:tracket/teams/providers/providers.dart';
import 'package:tracket/teams/providers/team_state.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/teams/widgets/capacity_selector.dart';
import 'package:tracket/teams/widgets/squad.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
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
  final _formKey = GlobalKey<FormState>();

  // State variables
  Uint8List? _image;
  int _maxPlayersCapacity = 11;
  String? _teamName;
  String? _teamShortName;
  String? _teamDescription;
  String? _captain;
  String? _wicketkeeper;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _teamState = ref.read(teamProvider);
    _maxPlayersCapacity = _teamState.team.maxPlayersCapacity;
    _initializeValues();
  }

  void _initializeValues() {
    _teamName = _teamState.team.name;
    _teamShortName = _teamState.team.shortName;
    _teamDescription = _teamState.team.description;
    _updateRoles();
  }

  void _updateRoles() {
    for (var player in _teamState.team.playersList) {
      if (player.id == _teamState.team.captainId) {
        _captain = player.name;
      }
      if (player.id == _teamState.team.wicketkeeperId) {
        _wicketkeeper = player.name;
      }
    }
  }

  List<String> get _playerNames =>
      _teamState.team.playersList.map((player) => player.name).toList();

  Future<void> _editLogo(Uint8List? image) async {
    try {
      final pickedImage = await pickImage(ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = pickedImage;
          _hasUnsavedChanges = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      showSnackBar('Failed to pick an image: $e', context);
    }
  }

  String? _getPlayerId(String? playerName) {
    if (playerName == null) return null;
    final player = _teamState.team.playersList
        .firstWhere((player) => player.name == playerName);
    return player.id;
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSaving = true);

    try {
      String? logoUrl;
      if (_image != null) {
        logoUrl = await SupabaseServices.uploadImage(
          imageByte: _image!,
          fileName: '${_teamState.team.id}.jpg',
          isExist: _teamState.team.logoUrl.isNotEmpty,
        );
      }

      await TeamsServices.updateTeamField(
        context,
        teamId: _teamState.team.id,
        teamName: _teamName,
        shortName: _teamShortName,
        description: _teamDescription,
        maxPlayersCapacity: _maxPlayersCapacity,
        captainId: _getPlayerId(_captain),
        wicketkeeperId: _getPlayerId(_wicketkeeper),
        logoUrl: logoUrl,
      );

      ref.read(teamProvider.notifier).updateField(
            name: _teamName!,
            shortName: _teamShortName,
            description: _teamDescription,
            maxPlayersCapacity: _maxPlayersCapacity,
            captainId: _getPlayerId(_captain),
            wicketkeeperId: _getPlayerId(_wicketkeeper),
            logoUrl: logoUrl,
          );

      if (mounted) {
        showSnackBar('Team updated successfully!', context);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;
      showSnackBar('Failed to update Team: $e', context);
    } finally {
      setState(() => _isSaving = false);
    }
  }

  bool _checkForChanges() {
    return _teamName != _teamState.team.name ||
        _teamShortName != _teamState.team.shortName ||
        _teamDescription != _teamState.team.description ||
        _maxPlayersCapacity != _teamState.team.maxPlayersCapacity ||
        _getPlayerId(_captain) != _teamState.team.captainId ||
        _getPlayerId(_wicketkeeper) != _teamState.team.wicketkeeperId ||
        _image != null;
  }

  @override
  Widget build(BuildContext context) {
    _teamState = ref.watch(teamProvider);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: !_hasUnsavedChanges && !_checkForChanges(),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (_checkForChanges()) {
          showAlertDoubleBtnDialog(
            context,
            title: 'Discard Changes?',
            content:
                'You have unsaved changes. Are you sure you want to discard them?',
            sureButtonText: 'Discard',
            onSureButtonPressed: () => Navigator.of(context).pop(),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: grassGreen,
          foregroundColor: LightThemeColors.surfaceColor,
          title: const Text(
            'Edit Team',
            style: TextStyle(
              color: LightThemeColors.surfaceColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            if (_isSaving)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: getCircleLoadingIndicator(
                  dimension: 24,
                  color: LightThemeColors.surfaceColor,
                ),
              )
            else
              IconButton(
                onPressed: _saveChanges,
                icon: const Icon(Icons.save_rounded),
                iconSize: 28,
                color: LightThemeColors.surfaceColor,
                tooltip: 'Save Changes',
              ),
            const SizedBox(width: 12),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Form(
              key: _formKey,
              onChanged: () => setState(() => _hasUnsavedChanges = true),
              child: Column(
                children: [
                  // Primary Info Section
                  MyCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Primary Information',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: darkGrassGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TeamLogoEditor(
                          logoUrl: _teamState.team.logoUrl,
                          image: _image,
                          onImageChanged: _editLogo,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          initialText: _teamState.team.name,
                          onSave: (value) => _teamName = value,
                          label: 'Team Name',
                          borderRadius: 12,
                          validator: (value) =>
                              ValidationServices.nameValidator(
                                  value, 'Team Name'),
                        ),
                        const SizedBox(height: 16),
                        MyTextField(
                          initialText: _teamState.team.shortName,
                          onSave: (value) => _teamShortName = value,
                          label: 'Team Short Name',
                          borderRadius: 12,
                          validator: ValidationServices.teamShortNameValidator,
                        ),
                        const SizedBox(height: 16),
                        MyTextField(
                          initialText: _teamState.team.description,
                          onSave: (value) => _teamDescription = value,
                          label: 'Description',
                          borderRadius: 12,
                          maxLength: 100,
                          maxLines: 3,
                          minLines: 2,
                        ),
                        const SizedBox(height: 16),
                        CapacitySelector(
                          capacity: _maxPlayersCapacity,
                          onIncrement: () {
                            if (_maxPlayersCapacity < 30) {
                              setState(() {
                                _maxPlayersCapacity++;
                                _hasUnsavedChanges = true;
                              });
                            } else {
                              showSnackBar(
                                'Maximum team capacity is 30 players',
                                context,
                              );
                            }
                          },
                          onDecrement: () {
                            if (_maxPlayersCapacity > 11) {
                              setState(() {
                                _maxPlayersCapacity--;
                                _hasUnsavedChanges = true;
                              });
                            } else {
                              showSnackBar(
                                'Minimum team capacity is 11 players',
                                context,
                              );
                            }
                          },
                          label: 'Team Capacity',
                        ),
                      ],
                    ),
                  ),

                  // Squad Section
                  const MyCard(child: Squad(isEdit: true)),

                  // Roles Section
                  MyCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Team Roles',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: darkGrassGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        MyDropdownMenu(
                          options: _playerNames,
                          label: 'Team Captain',
                          initialSelection: _captain,
                          onSelect: (value) => setState(() {
                            _captain = value;
                            _hasUnsavedChanges = true;
                          }),
                          leadingIcon: const Icon(Icons.star_outline),
                        ),
                        const SizedBox(height: 16),
                        MyDropdownMenu(
                          options: _playerNames,
                          label: 'Wicketkeeper',
                          initialSelection: _wicketkeeper,
                          onSelect: (value) => setState(() {
                            _wicketkeeper = value;
                            _hasUnsavedChanges = true;
                          }),
                          leadingIcon: const Icon(Icons.sports_cricket),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Save Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: size.width,
                      height: 50,
                      child: CustomButton.primary(
                        onPressed: _saveChanges,
                        text: 'Save Changes',
                        isLoading: _isSaving,
                        backgroundColor: grassGreen,
                        borderRadius: 10,
                        textStyle: theme.textTheme.titleMedium?.copyWith(
                          color: LightThemeColors.surfaceColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
