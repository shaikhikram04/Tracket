import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/teams/models/team_form_data.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/teams/utils/team_constants.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/validation_services.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_text_button.dart';
import 'package:tracket/widgets/custom_widgets/my_text_field.dart';

class CreateTeamScreen extends ConsumerStatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  ConsumerState<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends ConsumerState<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamFormData = TeamFormData();
  bool _isLoading = false;

  Future<void> _editLogo() async {
    try {
      final pickedImage = await pickImage(ImageSource.gallery);
      if (pickedImage != null) {
        setState(() => _teamFormData.logo = pickedImage);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar('Failed to pick image: ${e.toString()}', context);
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);
      _formKey.currentState!.save();
      final player = ref.read(playerProvider);

      if (_teamFormData.logo != null) {
        //! logic for uploading image on storage and get its url
      }

      final result = await TeamsServices.createTeam(
        teamName: _teamFormData.name!,
        shortName: _teamFormData.shortName!,
        createdBy: player.id,
        logoUrl: _teamFormData.logoUrl,
        adminName: player.name,
        adminCricketRole: player.playerCricketDetails!.cricketRole,
        description: _teamFormData.description!,
        ref: ref,
      );

      if (!mounted) return;
      if (result == 'success') {
        Navigator.of(context).pop();
        showSnackBar('Team Created Successfully', context);
      } else {
        showSnackBar('Some error occured. Please try again!', context);
      }
    } catch (e) {
      showSnackBar('An unexpected error occurred', context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Team'),
      ),
      body: _buildTeamForm(height),
    );
  }

  Widget _buildTeamForm(double height) {
    return Form(
      key: _formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(TeamConstants.defaultPadding),
          child: Column(
            children: [
              const Flexible(child: SizedBox(height: 30)),
              _buildTeamLogoSection(height),
              SizedBox(height: TeamConstants.defaultSpacing),
              _buildTeamInfoCard(),
              const Flexible(child: SizedBox(height: 30)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamLogoSection(double height) {
    return Column(
      children: [
        getCircleAvatar(
          url: '',
          isTeam: true,
          radius: height * 0.08,
          image: _teamFormData.logo,
        ),
        TextButton.icon(
          onPressed: _editLogo,
          label: const Text(
            'Edit team logo',
            style: TextStyle(color: blackColor),
            semanticsLabel: 'Edit team logo button',
          ),
          icon: const Icon(Icons.edit, semanticLabel: 'Edit icon'),
        ),
      ],
    );
  }

  Widget _buildTeamInfoCard() {
    return Card(
      color: lightCardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          children: [
            MyTextField(
              isLogin: false,
              onSave: (value) => _teamFormData.name = value,
              label: 'Team Name',
              borderRadius: 10,
              validator: (value) =>
                  ValidationServices.nameValidator(value, 'Team Name'),
            ),
            SizedBox(height: TeamConstants.defaultSpacing),
            MyTextField(
              isLogin: false,
              onSave: (value) => _teamFormData.shortName = value,
              label: 'Team Short Name',
              borderRadius: 10,
              validator: ValidationServices.teamShortNameValidator,
              maxLength: TeamConstants.maxShortNameLength,
            ),
            const SizedBox(height: 20),
            MyTextField(
              isLogin: false,
              onSave: (value) => _teamFormData.description = value,
              label: 'Team Description',
              borderRadius: 10,
              validator: (value) => null,
              maxLength: TeamConstants.maxTeamDescriptionLength,
              maxLines: 3,
              minLines: 2,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: _isLoading
                  ? getCircleLoadingIndicator()
                  : MyTextButton(
                      text: 'Create',
                      onPressed: () {
                        _handleSubmit();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
