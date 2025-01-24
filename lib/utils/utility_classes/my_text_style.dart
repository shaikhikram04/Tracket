import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class MyTextStyle {
  const MyTextStyle(this.context);

  final BuildContext context;

  TextTheme get textTheme => Theme.of(context).textTheme;

  //! Headings
  TextStyle get headlineSmall => textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w500,
        color: blackColor,
      );

  //! Title
  TextStyle get titleLarge => textTheme.titleLarge!;

  TextStyle coloredTitleLarge(Color textColor) => titleLarge.copyWith(
        color: textColor,
      );

  // TextStyle get cardTitleLarge => titleLarge.copyWith(color: darkGreenColor);

  TextStyle get profileTitleLarge => titleLarge.copyWith(fontSize: 20);

  TextStyle get titleMedium => textTheme.titleMedium!;

  TextStyle get profileTitleMedium => titleMedium.copyWith(fontSize: 16);

  //! Body
  TextStyle get bodyLarge => textTheme.bodyLarge!;

  TextStyle get boldBodyLarge => bodyLarge.copyWith(
        fontWeight: FontWeight.bold,
      );

  TextStyle get submitBtnTextStyle => bodyLarge.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: blackColor,
      );

  TextStyle buttonBodyLarge(Color textColor) => bodyLarge.copyWith(
        fontWeight: textColor == whiteColor ? FontWeight.w500 : FontWeight.w600,
        fontSize: 14,
        color: textColor,
      );

  TextStyle textButtonBodyLarge(bool isUnderlined) => bodyLarge.copyWith(
        decoration: isUnderlined ? TextDecoration.underline : null,
        color: Colors.black,
      );

  TextStyle coloredBodyLarge(Color textColor) =>
      bodyLarge.copyWith(color: textColor);

  TextStyle get subTitleBodyMedium => bodyMedium.copyWith(
        fontFamily: 'Inter',
        color: Colors.black87,
      );

  TextStyle get whiteBodyMedium => bodyMedium.copyWith(
        color: whiteColor,
        fontWeight: FontWeight.w400,
      );

  TextStyle get bodyMedium => textTheme.bodyMedium!;

  //! Label
  TextStyle coloredLabelLarge(Color textColor) =>
      textTheme.labelLarge!.copyWith(color: textColor);
}
