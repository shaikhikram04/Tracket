import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

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
    final isDark = THelperFunction.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
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
                    color: isDark ? lightGrassGreen : grassGreen,
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ImageCircleAvatar(
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
                    color: isDark ? lightGrassGreen : grassGreen,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? DarkThemeColors.surfaceColor
                          : LightThemeColors.surfaceColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: isDark
                        ? DarkThemeColors.surfaceColor
                        : LightThemeColors.surfaceColor,
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
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? lightGrassGreen : grassGreen,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Upload a team logo here',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: isDark
                            ? DarkThemeColors.secondaryText
                            : LightThemeColors.secondaryText,
                      ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => onImageChanged(image),
                  style: TextButton.styleFrom(
                    foregroundColor: isDark ? lightGrassGreen : grassGreen,
                    backgroundColor: isDark
                        ? DarkThemeColors.surfaceColor
                        : LightThemeColors.surfaceColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.edit),
                  label: Text('Change Logo',
                      style: Theme.of(context).textTheme.labelLarge),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
