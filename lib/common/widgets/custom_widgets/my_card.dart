import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class MyCard extends StatelessWidget {
  const MyCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return Card(
      margin: TPadding.paddingLg,
      color:
          isDark ? DarkThemeColors.surfaceColor : LightThemeColors.surfaceColor,
      elevation: TSizes.cardElevationXl,
      child: Padding(
        padding: TPadding.cardPaddingLg,
        child: child,
      ),
    );
  }
}
