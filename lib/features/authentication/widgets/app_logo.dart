import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/image_strings.dart';
import 'package:tracket/utils/devices/devices_utility.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});
  static const double _maxLogoHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);
    final height = TDeviceUtils.getScreenHeight(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Image.asset(
        isDark ? TImages.appLogoDark : TImages.appLogo,
        height: height * 0.25 > _maxLogoHeight ? _maxLogoHeight : height * 0.25,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, size: 100),
      ),
    );
  }
}
