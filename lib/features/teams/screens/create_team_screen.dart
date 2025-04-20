import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:tracket/common/widgets/custom_widgets/my_text_field.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/features/matches/models/match.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/features/teams/models/team_form_data.dart';
import 'package:tracket/features/teams/services/teams_services.dart';
import 'package:tracket/features/teams/utils/team_constants.dart';
import 'package:tracket/utils/cloud_storage/supabase_services.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/validation_services.dart';

class CreateTeamScreen extends ConsumerStatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  ConsumerState<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends ConsumerState<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamFormData = TeamFormData();
  final _scrollController = ScrollController();
  final _nameController = TextEditingController();
  final _shortNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;
  bool _isPrivate = false;
  bool _autoValidate = false;
  String? _imageError;

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _shortNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _editLogo() async {
    try {
      final pickedImage = await THelperFunction.pickImageFromGalleryPath();
      if (pickedImage == null) return;

      final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 70,
        maxWidth: 500,
        maxHeight: 500,
        compressFormat: ImageCompressFormat.jpg,
      );

      if (croppedImage != null) {
        setState(() async {
          _teamFormData.logo = await croppedImage.readAsBytes();
          _imageError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        THelperFunction.showSnackBar(
            'Failed to pick image: ${e.toString()}', context);
      }
    }
  }

  Future<void> _handleSubmit() async {
    setState(() => _autoValidate = true);

    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);
      _formKey.currentState!.save();
      final player = ref.read(playerProvider);

      final teamId = uuid.v4();

      if (_teamFormData.logo != null) {
        final logoUrl = await SupabaseServices.uploadImage(
          imageByte: _teamFormData.logo!,
          fileName: teamId,
          isExist: false,
          isProfile: false,
        );
        if (logoUrl != null) {
          _teamFormData.logoUrl = logoUrl;
        } else {
          setState(() => _imageError = 'Failed to upload logo image');
          return;
        }
      }

      final result = await TeamsServices.createTeam(
        teamId: teamId,
        teamName: _teamFormData.name!,
        shortName: _teamFormData.shortName!,
        createdBy: player.id,
        logoUrl: _teamFormData.logoUrl,
        adminName: player.name,
        adminCricketRole: player.playerCricketDetails!.cricketRole,
        description: _teamFormData.description!,
        isPrivate: _isPrivate,
        maxPlayers: _teamFormData.maxPlayers ?? TeamConstants.defaultMaxPlayers,
        ref: ref,
        longCricketRole: player.playerCricketDetails!.detailedCricketRole,
      );

      if (!mounted) return;

      if (result == 'success') {
        Navigator.of(context).pop();
        THelperFunction.showSnackBar('Team Created Successfully', context);
      } else {
        THelperFunction.showSnackBar('Failed to create team: $result', context);
      }
    } catch (e) {
      THelperFunction.showSnackBar('An unexpected error occurred', context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTeamLogoSection(double height, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? lightGrassGreen.withValues(alpha: 0.2)
                : grassGreen.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? lightGrassGreen.withValues(alpha: 0.3)
                        : grassGreen.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
                child: ImageCircleAvatar(
                  url: '',
                  isTeam: true,
                  radius: height * 0.08,
                  image: _teamFormData.logo,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? lightGrassGreen.withValues(alpha: 0.3)
                            : grassGreen.withValues(alpha: 0.3),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: isDark ? primaryLight : grassGreen,
                    radius: 18,
                    child: IconButton(
                      icon: const Icon(Icons.edit, size: 18, color: onPrimary),
                      onPressed: _editLogo,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_imageError != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _imageError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTeamInfoCard(bool isDark) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color:
          isDark ? DarkThemeColors.surfaceColor : LightThemeColors.surfaceColor,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark ? Colors.black : Colors.white,
              isDark
                  ? DarkThemeColors.secondaryBackground.withValues(alpha: 0.5)
                  : LightThemeColors.secondaryBackground.withValues(alpha: 0.5),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Team Information', isDark),
              const SizedBox(height: 20),
              MyTextField(
                onSave: (value) => _teamFormData.name = value,
                label: 'Team Name',
                validator: (value) =>
                    ValidationServices.nameValidator(value, 'Team Name'),
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                prefixIcon: Icons.group,
              ),
              const SizedBox(height: TeamConstants.defaultSpacing),
              MyTextField(
                onSave: (value) => _teamFormData.shortName = value,
                label: 'Team Short Name',
                validator: ValidationServices.teamShortNameValidator,
                maxLength: TeamConstants.maxShortNameLength,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                prefixIcon: Icons.short_text,
              ),
              const SizedBox(height: 20),
              MyTextField(
                onSave: (value) => _teamFormData.description = value,
                label: 'Team Description',
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please add a team description'
                    : null,
                maxLength: TeamConstants.maxTeamDescriptionLength,
                maxLines: 3,
                minLines: 2,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                prefixIcon: Icons.description,
              ),
              const SizedBox(height: 30),
              _buildAdvancedSettings(isDark),
              const SizedBox(height: 30),
              _buildSubmitButton(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? lightGrassGreen.withValues(alpha: 0.1)
            : grassGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? lightGrassGreen.withValues(alpha: 0.2)
              : grassGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? lightGrassGreen : grassGreen,
        ),
      ),
    );
  }

  Widget _buildAdvancedSettings(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Advanced Settings', isDark),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? DarkThemeColors.secondaryBackground.withValues(alpha: 0.5)
                : LightThemeColors.secondaryBackground.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDark
                  ? lightGrassGreen.withValues(alpha: 0.2)
                  : grassGreen.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Private Team'),
                subtitle: Text(
                  'Only invited players can join',
                  style: TextStyle(
                      color: isDark
                          ? DarkThemeColors.secondaryText
                          : LightThemeColors.secondaryText),
                ),
                value: _isPrivate,
                onChanged: (value) => setState(() => _isPrivate = value),
                activeColor: isDark ? lightGrassGreen : grassGreen,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.people,
                      color: isDark ? lightGrassGreen : grassGreen),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Maximum Players',
                      style: TextStyle(
                          color: isDark ? lightGrassGreen : grassGreen),
                    ),
                  ),
                  const Text(' : '),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? DarkThemeColors.surfaceColor
                          : LightThemeColors.surfaceColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? lightGrassGreen.withValues(alpha: 0.3)
                            : grassGreen.withValues(alpha: 0.3),
                      ),
                    ),
                    child: DropdownButton<int>(
                      value: _teamFormData.maxPlayers ??
                          TeamConstants.defaultMaxPlayers,
                      menuMaxHeight: 400,
                      items: List.generate(
                        TeamConstants.maxTeamSize -
                            TeamConstants.minTeamSize +
                            1,
                        (index) => DropdownMenuItem(
                          value: index + TeamConstants.minTeamSize,
                          child: Text('${index + TeamConstants.minTeamSize}'),
                        ),
                      ),
                      onChanged: (value) =>
                          setState(() => _teamFormData.maxPlayers = value),
                      underline: const SizedBox(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isDark) {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? lightGrassGreen : grassGreen,
              ),
            )
          : Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    isDark ? lightGrassGreen : grassGreen,
                    isDark ? primaryLight : darkGrassGreen,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? lightGrassGreen.withValues(alpha: 0.3)
                        : grassGreen.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Create Team',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? DarkThemeColors.cardColor : onPrimary,
                  ),
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final isDark = THelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: onPrimary,
        backgroundColor: grassGreen,
        title: const Text(
          'Create Team',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(TeamConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: TSizes.defaultSpace),
              _buildTeamLogoSection(height, isDark),
              const SizedBox(height: TSizes.defaultSpace),
              _buildTeamInfoCard(isDark),
              const SizedBox(height: TSizes.defaultSpace),
            ],
          ),
        ),
      ),
    );
  }
}
