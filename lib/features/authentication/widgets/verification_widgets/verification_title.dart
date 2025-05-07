import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class VerificationTitle extends StatelessWidget {
  const VerificationTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: TSizes.sm,
      children: [
        Icon(
          Icons.lock_outline,
          color: isDark ? primaryLight : primaryVariant,
          size: TSizes.iconMd,
        ),
        Text(
          TTextStrings.authentication,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w800,
                color: isDark ? primaryLight : primaryVariant,
              ),
        ),
      ],
    );
  }
}
