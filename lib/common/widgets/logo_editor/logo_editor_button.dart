import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class LogoEditorButton extends StatelessWidget {
  const LogoEditorButton({
    super.key,
    required this.onImageChanged,
    required this.image,
  });

  final void Function(Uint8List? p1) onImageChanged;
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);
    
    return TextButton.icon(
      onPressed: () => onImageChanged(image),
      style: TextButton.styleFrom(
        foregroundColor: isDark
            ? DarkThemeColors.surfaceColor
            : LightThemeColors.surfaceColor,
        backgroundColor: isDark ? lightGrassGreen : grassGreen,
        padding: TPadding.paddingXs,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
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
    );
  }
}
