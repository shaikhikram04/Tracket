import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';

class ResendVerificationEmailButton extends StatelessWidget {
  const ResendVerificationEmailButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: TPadding.xs,
        decoration: BoxDecoration(
          color: isDark ? primaryLight : primaryVariant,
          borderRadius: BorderRadius.circular(TSizes.buttonRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            const Icon(AppIconData.email, color: LightThemeColors.surfaceColor),
            Flexible(
              child: Text(
                TTextStrings.resendVerificationEmail,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: LightThemeColors.surfaceColor,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
