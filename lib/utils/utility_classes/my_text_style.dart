import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

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
        color: LightThemeColors.surfaceColor,
      );

  TextStyle get mediumButtonText => bodyMedium.copyWith(
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

  //! Used in code
  // MyTextStyle(context).headlineMedium.copyWith(
  //                             fontWeight: FontWeight.bold,
  //                             color: darkGreenTextColor,
  //                             letterSpacing: 0.5,
  //                           ),
}
