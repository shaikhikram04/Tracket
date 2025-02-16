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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: grassGreen,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: getCircleAvatar(
                  url: logoUrl,
                  isTeam: true,
                  radius: 50,
                  image: image,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: grassGreen,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: whiteColor,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: whiteColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Team Logo',
                  style: MyTextStyle(context).titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: grassGreen,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Upload a team logo here',
                  style: MyTextStyle(context).bodyMedium.copyWith(
                        color: secondaryTextColor,
                      ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => onImageChanged(image),
                  style: TextButton.styleFrom(
                    foregroundColor: grassGreen,
                    backgroundColor: onLightDrawer,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.edit),
                  label: Text(
                    'Change Logo',
                    style: MyTextStyle(context).bodyLarge.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
