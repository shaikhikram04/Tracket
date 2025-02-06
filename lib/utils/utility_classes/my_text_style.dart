import 'package:flutter/material.dart';

class MyTextStyle {
  const MyTextStyle(this.context);
  final BuildContext context;

  TextTheme get textTheme => Theme.of(context).textTheme;

  //! DISPLAY STYLES
  TextStyle get displayLarge => textTheme.displayLarge!.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: -1.5,
      );

  TextStyle get displayMedium => textTheme.displayMedium!.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  TextStyle get displaySmall => textTheme.displaySmall!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      );

  //! HEADLINE STYLES
  TextStyle get headlineLarge => textTheme.headlineLarge!.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  TextStyle get headlineMedium => textTheme.headlineMedium!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
      );

  TextStyle get headlineSmall => textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      );

  //! TITLE STYLES
  TextStyle get titleLarge => textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      );

  TextStyle get titleMedium => textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  TextStyle get titleSmall => textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  //! LABEL STYLES
  TextStyle get labelLarge => textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  TextStyle get labelMedium => textTheme.labelMedium!.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  TextStyle get labelSmall => textTheme.labelSmall!.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  //! BODY STYLES
  TextStyle get bodyLarge => textTheme.bodyLarge!.copyWith(
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      );

  TextStyle get bodyMedium => textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      );

  TextStyle get bodySmall => textTheme.bodySmall!.copyWith(
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      );

  //! SPECIALIZED STYLES
  TextStyle get appBarTitle => titleLarge.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  TextStyle get cardTitle => titleMedium.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  TextStyle get cardSubtitle => bodyMedium.copyWith(
        color: Colors.black87,
        height: 1.3,
      );

  TextStyle get buttonText => bodyLarge.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  TextStyle get caption => bodySmall.copyWith(
        color: Colors.black54,
        height: 1.4,
      );

  //! UTILITY METHODS
  TextStyle withColor(TextStyle base, Color color) =>
      base.copyWith(color: color);

  TextStyle withWeight(TextStyle base, FontWeight weight) =>
      base.copyWith(fontWeight: weight);

  TextStyle withSize(TextStyle base, double size) =>
      base.copyWith(fontSize: size);

  //! COMPONENT-SPECIFIC STYLES
  TextStyle get formLabel => labelMedium.copyWith(
        color: Colors.black87,
        height: 1.5,
      );

  TextStyle get formInput => bodyLarge.copyWith(
        height: 1.5,
        letterSpacing: 0.2,
      );

  TextStyle get errorText => bodySmall.copyWith(
        color: Colors.red,
        height: 1.4,
      );

  TextStyle get chipText => labelMedium.copyWith(
        letterSpacing: 0.1,
        height: 1.2,
      );

  TextStyle get tooltipText => labelSmall.copyWith(
        color: Colors.white,
        height: 1.2,
      );

  //! EMPHASIS VARIATIONS
  TextStyle get emphasisHigh => bodyLarge.copyWith(
        color: Colors.black87,
        height: 1.5,
      );

  TextStyle get emphasisMedium => bodyLarge.copyWith(
        color: Colors.black54,
        height: 1.5,
      );

  TextStyle get emphasisLow => bodyLarge.copyWith(
        color: Colors.black38,
        height: 1.5,
      );

  // TextStyle get profileTitleLarge => titleLarge.copyWith(fontSize: 20);

  // TextStyle get profileTitleMedium => titleMedium.copyWith(fontSize: 16);

  // TextStyle get boldBodyLarge => bodyLarge.copyWith(
  //       fontWeight: FontWeight.bold,
  //     );

  // TextStyle get submitBtnTextStyle => bodyLarge.copyWith(
  //       fontWeight: FontWeight.bold,
  //       fontSize: 18,
  //       color: blackColor,
  //     );

  // TextStyle buttonBodyLarge(Color textColor) => bodyLarge.copyWith(
  //       fontWeight: textColor == whiteColor ? FontWeight.w500 : FontWeight.w600,
  //       fontSize: 14,
  //       color: textColor,
  //     );

  // TextStyle textButtonBodyLarge(bool isUnderlined) => bodyLarge.copyWith(
  //       decoration: isUnderlined ? TextDecoration.underline : null,
  //       color: Colors.black,
  //     );

  // TextStyle coloredBodyLarge(Color textColor) =>
  //     bodyLarge.copyWith(color: textColor);

  // TextStyle get subTitleBodyMedium => bodyMedium.copyWith(
  //       fontFamily: 'Inter',
  //       color: Colors.black87,
  //     );

  // TextStyle get whiteBodyMedium => bodyMedium.copyWith(
  //       color: whiteColor,
  //       fontWeight: FontWeight.w400,
  //     );

  // TextStyle coloredBodyMedium(Color textColor) =>
  //     bodyMedium.copyWith(color: textColor);

  // //! Label
  // TextStyle coloredLabelLarge(Color textColor) =>
  //     textTheme.labelLarge!.copyWith(color: textColor);
}
