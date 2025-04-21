import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';
import 'package:tracket/common/widgets/custom_widgets/my_dropdown_menu.dart';
import 'package:tracket/common/widgets/custom_widgets/my_text_field.dart';
import 'package:tracket/common/widgets/team_logo_editor.dart';
import 'package:tracket/features/teams/providers/providers.dart';
import 'package:tracket/features/teams/providers/team_state.dart';
import 'package:tracket/features/teams/services/teams_services.dart';
import 'package:tracket/features/teams/utils/team_constants.dart';
import 'package:tracket/features/teams/widgets/capacity_selector.dart';
import 'package:tracket/features/teams/widgets/squad.dart';
import 'package:tracket/utils/cloud_storage/supabase_services.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/validator/validator.dart';

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
  late int _maxPlayersCapacity ;
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
      final pickedImage = await THelperFunction.pickImage(ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = pickedImage;
          _hasUnsavedChanges = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      THelperFunction.showSnackBar('${TTextStrings.failedToPickImage} $e', context);
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
          isProfile: false,
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
        THelperFunction.showSnackBar(TTextStrings.teamUpdated, context);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;
      THelperFunction.showSnackBar('${TTextStrings.failedToUpdateTeam} $e', context);
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

    final isDark = THelperFunction.isDarkMode(context);

    return PopScope(
      canPop: !_hasUnsavedChanges && !_checkForChanges(),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (_checkForChanges()) {
          final isDiscard = await THelperFunction.showConfirmationDialog(
            context,
            title: TTextStrings.discardChanges,
            message:
                TTextStrings.discardChangesMessage,
            confirmText: TTextStrings.discardButton,
          );
          if (isDiscard) {
            Navigator.of(context).pop();
          }
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: grassGreen,
          foregroundColor: onPrimary,
          title:  const Text(
            TTextStrings.editTeam,
            style: TextStyle(
              color: onPrimary,
            ),
          ),
          actions: [
            if (_isSaving)
              const Padding(
                padding: TPadding.sm,
                child:
                    CircularLoadingIndicator(dimension: TSizes.xxl, color: onPrimary),
              )
            else
              IconButton(
                onPressed: _saveChanges,
                icon: const Icon(Icons.save_rounded),
                iconSize: TSizes.iconAppBar,
                color: onPrimary,
              ),
            const SizedBox(width: TSizes.md),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: TPadding.vPaddingLg,
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
                          TTextStrings.primaryInformation,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: isDark ? lightGrassGreen : darkGrassGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: TSizes.xl),
                        TeamLogoEditor(
                          logoUrl: _teamState.team.logoUrl,
                          image: _image,
                          onImageChanged: _editLogo,
                        ),
                        const SizedBox(height: TSizes.xl),
                        MyTextField(
                          initialText: _teamState.team.name,
                          onSave: (value) => _teamName = value,
                          label: TTextStrings.teamName,
                          validator: (value) =>
                              TValidator.nameValidator(value, TTextStrings.teamName),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        MyTextField(
                          initialText: _teamState.team.shortName,
                          onSave: (value) => _teamShortName = value,
                          label: TTextStrings.teamShortName,
                          validator: TValidator.teamShortNameValidator,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        MyTextField(
                          initialText: _teamState.team.description,
                          onSave: (value) => _teamDescription = value,
                          label: TTextStrings.teamDescription,
                          maxLength: TeamConstants.maxTeamDescriptionLength,
                          maxLines: 3,
                          minLines: 2,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        CapacitySelector(
                          capacity: _maxPlayersCapacity,
                          onIncrement: () {
                            if (_maxPlayersCapacity < TeamConstants.maxTeamSize) {
                              setState(() {
                                _maxPlayersCapacity++;
                                _hasUnsavedChanges = true;
                              });
                            } else {
                              THelperFunction.showSnackBar(
                                TTextStrings.maxTeamCapacityReached,
                                context,
                              );
                            }
                          },
                          onDecrement: () {
                            if (_maxPlayersCapacity > TeamConstants.minTeamSize) {
                              setState(() {
                                _maxPlayersCapacity--;
                                _hasUnsavedChanges = true;
                              });
                            } else {
                              THelperFunction.showSnackBar(
                                TTextStrings.minTeamCapacityReached,
                                context,
                              );
                            }
                          },
                          label: TTextStrings.teamCapacity,
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
                          TTextStrings.teamRoles,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: isDark ? lightGrassGreen : darkGrassGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: TSizes.xl),
                        MyDropdownMenu(
                          options: _playerNames,
                          label: TTextStrings.teamCapacity,
                          initialSelection: _captain,
                          onSelect: (value) => setState(() {
                            _captain = value;
                            _hasUnsavedChanges = true;
                          }),
                          leadingIcon: const Icon(Icons.star_outline),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        MyDropdownMenu(
                          options: _playerNames,
                          label: TTextStrings.teamWicketkeeper,
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
                  const SizedBox(height: TSizes.sm),

                  // Save Button
                  Padding(
                    padding: TPadding.hPaddingLg,
                    child: SizedBox(
                      width: size.width,
                      height: TSizes.buttonHeight,
                      child: CustomButton.primary(
                        onPressed: _saveChanges,
                        text: TTextStrings.saveChangesButton,
                        isLoading: _isSaving,
                        backgroundColor: isDark ? lightGrassGreen : grassGreen,
                        borderRadius: TSizes.borderRadiusLg,
                        textStyle: theme.textTheme.titleMedium?.copyWith(
                          color: onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
