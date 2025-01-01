import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class TeamLogoEditor extends StatelessWidget {
  const TeamLogoEditor({
    super.key,
    required this.image,
    required this.logoUrl,
    required this.onImageChanged,
  });

  final Uint8List? image;
  final String logoUrl;
  final void Function(Uint8List?) onImageChanged;

  ImageProvider<Object> _getTeamLogo() {
    if (image != null) {
      return MemoryImage(image!);
    } else if (logoUrl.isNotEmpty) {
      return NetworkImage(logoUrl);
    } else {
      return const AssetImage('assets/images/team_logo.png');
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
          onPressed: () => onImageChanged(image),
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
