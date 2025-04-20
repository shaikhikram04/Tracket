import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';

class MyCard extends StatelessWidget {
  const MyCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: TPadding.paddingLg,
      color: LightThemeColors.surfaceColor,
      elevation: TSizes.cardElevationXl,
      child: Padding(
        padding: TPadding.cardPaddingLg,
        child: child,
      ),
    );
  }
}
