import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_text_button.dart';
import 'package:tracket/widgets/custom_widgets/my_text_field.dart';

class CreateTeamScreen extends ConsumerStatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  ConsumerState<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends ConsumerState<CreateTeamScreen> {
  late GlobalKey<FormState> _formKey;
  String? _teamName;
  String? _teamShortName;
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  Future<void> _editLogo() async {
    final pickedImage = await pickImage(ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  Future<void> _createTeam(
    String playerId,
    String playerName,
    String playerRole,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    _formKey.currentState!.save();

    String teamLogoUrl = '';
    if (_image != null) {
      //! logic for uploading image on storage and get its url
    }

    final result = await TeamsServices.createTeam(
      teamName: _teamName!,
      shortName: _teamShortName!,
      createdBy: playerId,
      logoUrl: teamLogoUrl,
      adminName: playerName,
      adminCricketRole: playerRole,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;
    if (result == 'success') {
      Navigator.of(context).pop();
      showSnackBar('Team Created Successfully', context);
    } else {
      showSnackBar('Some error occured. Please try again!', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerProvider);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Team'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Flexible(child: SizedBox(height: 30)),
                CircleAvatar(
                    radius: height * 0.08,
                    backgroundImage: _image != null
                        ? MemoryImage(_image!)
                        : const AssetImage('assets/images/team_logo.png')),
                TextButton.icon(
                  onPressed: _editLogo,
                  label: const Text(
                    'Edit team logo',
                    style: TextStyle(color: blackColor),
                    semanticsLabel: 'Edit team logo button',
                  ),
                  icon: const Icon(Icons.edit, semanticLabel: 'Edit icon'),
                ),
                const SizedBox(height: 20),
                Card(
                  color: lightCardColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 25),
                    child: Column(
                      children: [
                        MyTextField(
                          isLogin: false,
                          onSave: (value) => _teamName = value,
                          label: 'Team Name',
                          borderRadius: 10,
                          validator: (value) =>
                              nameValidator(value, 'Team Name'),
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          isLogin: false,
                          onSave: (value) => _teamShortName = value,
                          label: 'Team Short Name',
                          borderRadius: 10,
                          validator: teamShortNameValidator,
                          maxLength: 4,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          isLogin: false,
                          onSave: (value) => _teamShortName = value,
                          label: 'Team Description',
                          borderRadius: 10,
                          validator: teamShortNameValidator,
                          maxLength: 100,
                          maxLines: 3,
                          minLines: 2,
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : MyTextButton(
                                  text: 'Create',
                                  onPressed: () {
                                    _createTeam(
                                      player.id,
                                      player.name,
                                      player.detailedCricketRole,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Flexible(child: SizedBox(height: 30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
