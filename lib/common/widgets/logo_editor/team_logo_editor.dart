import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/logo_editor/logo_editor_button.dart';
import 'package:tracket/common/widgets/logo_editor/logo_editor_icon.dart';
import 'package:tracket/common/widgets/logo_editor/logo_editor_image.dart';
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
        spacing: TSizes.xl,
        children: [
          Stack(
            children: [
              LogoEditorImage(logoUrl: logoUrl, image: image),
              const LogoEditorIcon(),
            ],
          ),
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
                LogoEditorButton(
                  onImageChanged: onImageChanged,
                  image: image,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
