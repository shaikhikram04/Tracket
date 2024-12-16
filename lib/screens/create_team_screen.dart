import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/resources/firebase_auth_methods.dart';
import 'package:tracket/resources/firestore_methods.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/my_text_button.dart';
import 'package:tracket/widgets/my_text_field.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  late GlobalKey<FormState> _formKey;
  String? _teamName;
  String? _teamShortName;
  Uint8List? _image;
  bool _isAdminWantToBePlayer = false;

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

  Future<void> _createTeam() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    String? teamLogoUrl;
    if (_image != null) {
      //! logic for uploading image on storage and get its url
    }

    final result = await FirestoreMethods.createTeam(
      teamName: _teamName!,
      shortName: _teamShortName!,
      createdBy: FirebaseAuthMethods.currentUserId,
      logoUrl: teamLogoUrl,
      adminName: '',
      adminCricketRole: '',
    );

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
                  ),
                  icon: const Icon(Icons.edit),
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
                          onSave: (value) => _teamName = value,
                          label: 'Team Name',
                          borderRadius: 10,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          onSave: (value) => _teamShortName = value,
                          label: 'Team Short Name',
                          borderRadius: 10,
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: MyTextButton(
                            text: 'Create',
                            onPressed: _createTeam,
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
