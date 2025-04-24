import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
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
      padding: TPadding.md,
      decoration: BoxDecoration(
        color: isDark
            ? DarkThemeColors.secondaryBackground
            : LightThemeColors.secondaryBackground,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: TSizes.blurRadiusMd,
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
                      blurRadius: TSizes.blurRadiusMd,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ImageCircleAvatar(
                  url: logoUrl,
                  isTeam: true,
                  radius: TSizes.circleAvatarLg,
                  image: image,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: TPadding.xxs,
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
                    size: TSizes.iconSm,
                    color: isDark
                        ? DarkThemeColors.surfaceColor
                        : LightThemeColors.surfaceColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: TSizes.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  TTextStrings.teamLogo,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? lightGrassGreen : grassGreen,
                      ),
                ),
                const SizedBox(height: TSizes.xs),
                Text(
                  TTextStrings.teamLogoMessage,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: isDark
                            ? DarkThemeColors.secondaryText
                            : LightThemeColors.secondaryText,
                      ),
                ),
                const SizedBox(height: TSizes.sm),
                TextButton.icon(
                  onPressed: () => onImageChanged(image),
                  style: TextButton.styleFrom(
                    foregroundColor: isDark
                        ? DarkThemeColors.surfaceColor
                        : LightThemeColors.surfaceColor,
                    backgroundColor: isDark ? lightGrassGreen : grassGreen,
                    padding: TPadding.paddingXs,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(TSizes.borderRadiusMd),
                    ),
                  ),
                  icon: Icon(
                    Icons.edit,
                    color: isDark
                        ? DarkThemeColors.surfaceColor
                        : LightThemeColors.surfaceColor,
                    size: TSizes.iconSm,
                  ),
                  label: Text(TTextStrings.changeLogo,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: isDark
                                ? DarkThemeColors.surfaceColor
                                : LightThemeColors.surfaceColor,
                            fontWeight: FontWeight.w600,
                          )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
