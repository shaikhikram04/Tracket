import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/image_strings.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/devices/devices_utility.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.withName = false});

  final bool withName;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);
    final height = TDeviceUtils.getScreenHeight(context);

    return Padding(
      padding: TPadding.vPaddingXl,
      child: Image.asset(
        withName
            ? isDark
                ? TImages.appLogoWithNameDark
                : TImages.appLogoWithName
            : isDark
                ? TImages.appLogoDark
                : TImages.appLogo,
        height: height * 0.15,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, size: TSizes.appLogoHeightMin),
      ),
    );
  }
}
