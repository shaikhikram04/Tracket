import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/resources/image_kit_upload_service.dart';
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
  File? _image;

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
    final ImageKitUploadService uploadService = ImageKitUploadService(
      publicKey: dotenv.get('PUBLIC_API_KEY'),
      privateKey: dotenv.get('PRIVATE_API_KEY'),
      urlEndpoint: dotenv.get('URL_ENDPOINT'),
    );
    final uploadedImageUrl = await uploadService.uploadImage(
      imageFile: _image!,
      fileName: 'teamlogo',
      folder: '/user_uploads',
      customMetadata: {
        'userId': '12345',
        'uploadSource': 'mobile_app',
      },
    );

    if (uploadedImageUrl != null) {
      print('Image uploaded successfully: $uploadedImageUrl');
    } else {
      print('Upload failed');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 50),
                CircleAvatar(
                    radius: 70,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
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
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 25),
                    child: Column(
                      children: [
                        MyTextField(
                          onSave: (value) => _teamName = value,
                          label: 'Team Name',
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          onSave: (value) => _teamShortName = value,
                          label: 'Team Short Name',
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: MyTextButton(
                            text: 'Create',
                            onPressed: _createTeam,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
