import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';

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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        getCircleAvatar(url: logoUrl, isTeam: true, radius: 50, image: image),
        const SizedBox(width: 15),
        TextButton.icon(
          onPressed: () => onImageChanged(image),
          label: Text(
            'Edit team logo',
            style: MyTextStyle(context).bodyLarge,
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
