import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class TitleText {
  const TitleText(this.context);

  final BuildContext context;

  bool get isDark => THelperFunction.isDarkMode(context);

  Text get titleText1 => Text(
        TTextStrings.forgetPassword,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? lightGrassGreen : grassGreen,
              letterSpacing: 0.5,
            ),
      );
}
