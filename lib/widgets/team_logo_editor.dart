import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';

class TeamLogoEditor extends StatefulWidget {
  const TeamLogoEditor({super.key, required this.logoUrl});

  final String? logoUrl;

  @override
  State<TeamLogoEditor> createState() => _TeamLogoEditorState();
}

class _TeamLogoEditorState extends State<TeamLogoEditor> {
  Uint8List? _image;

  ImageProvider<Object> _getTeamLogo() {
    if (_image != null) {
      return MemoryImage(_image!);
    } else if (widget.logoUrl != null) {
      return NetworkImage(widget.logoUrl!);
    } else {
      return const AssetImage('assets/images/team_logo.png');
    }
  }

  Future<void> _editLogo() async {
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          backgroundImage: _getTeamLogo(),
        ),
        const SizedBox(width: 15),
        TextButton.icon(
          onPressed: _editLogo,
          label: Text(
            'Edit team logo',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          style: TextButton.styleFrom(
            foregroundColor: blackColor,
            backgroundColor: lightCardColor,
            iconColor: blackColor,
          ),
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }
}
