import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/teams/models/team_form_data.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/teams/utils/team_constants.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/validation_services.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_text_field.dart';

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
      final pickedImage = await pickImageFromGalleryPath();
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
        showSnackBar('Failed to pick image: ${e.toString()}', context);
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

      if (_teamFormData.logo != null) {
        // TODO: Implement image upload logic
        // _teamFormData.logoUrl = await uploadImage(_teamFormData.logo!);
      }

      final result = await TeamsServices.createTeam(
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
        showSnackBar('Team Created Successfully', context);
      } else {
        showSnackBar('Failed to create team: $result', context);
      }
    } catch (e) {
      showSnackBar('An unexpected error occurred', context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTeamLogoSection(double height) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: grassGreen.withValues(alpha: 0.2),
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
                    color: grassGreen.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
                child: getCircleAvatar(
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
                        color: grassGreen.withValues(alpha: 0.3),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: grassGreen,
                    radius: 18,
                    child: IconButton(
                      icon:
                          const Icon(Icons.edit, size: 18, color: Colors.white),
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

  Widget _buildTeamInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: whiteColor,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              lightBackgroundColor2.withValues(alpha: 0.5),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Team Information'),
              const SizedBox(height: 20),
              MyTextField(
                isLogin: false,
                onSave: (value) => _teamFormData.name = value,
                label: 'Team Name',
                borderRadius: 12,
                fillColor: Colors.white,
                validator: (value) =>
                    ValidationServices.nameValidator(value, 'Team Name'),
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                prefixIcon: Icons.group,
                primaryColor: grassGreen,
              ),
              SizedBox(height: TeamConstants.defaultSpacing),
              MyTextField(
                isLogin: false,
                onSave: (value) => _teamFormData.shortName = value,
                label: 'Team Short Name',
                borderRadius: 12,
                fillColor: Colors.white,
                validator: ValidationServices.teamShortNameValidator,
                maxLength: TeamConstants.maxShortNameLength,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                prefixIcon: Icons.short_text,
                primaryColor: grassGreen,
              ),
              const SizedBox(height: 20),
              MyTextField(
                isLogin: false,
                onSave: (value) => _teamFormData.description = value,
                label: 'Team Description',
                borderRadius: 12,
                fillColor: Colors.white,
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
                primaryColor: grassGreen,
              ),
              const SizedBox(height: 30),
              _buildAdvancedSettings(),
              const SizedBox(height: 30),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: grassGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: grassGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: grassGreen,
        ),
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Advanced Settings'),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lightBackgroundColor2.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: grassGreen.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Private Team'),
                subtitle: Text(
                  'Only invited players can join',
                  style: TextStyle(color: secondaryTextColor),
                ),
                value: _isPrivate,
                onChanged: (value) => setState(() => _isPrivate = value),
                activeColor: grassGreen,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.people, color: grassGreen),
                  const SizedBox(width: 12),
                  Text(
                    'Maximum Players:',
                    style: TextStyle(color: textGrassGreen),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: grassGreen.withValues(alpha: 0.3),
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

  Widget _buildSubmitButton() {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(grassGreen),
            )
          : Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [grassGreen, darkGrassGreen],
                ),
                boxShadow: [
                  BoxShadow(
                    color: grassGreen.withValues(alpha: 0.3),
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
                child: const Text(
                  'Create Team',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: lightBackgroundColor2,
      appBar: AppBar(
        foregroundColor: whiteColor,
        title: const Text(
          'Create Team',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: grassGreen,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(TeamConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildTeamLogoSection(height),
              SizedBox(height: TeamConstants.defaultSpacing),
              _buildTeamInfoCard(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
