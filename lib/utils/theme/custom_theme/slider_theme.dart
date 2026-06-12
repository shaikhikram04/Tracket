import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';

class TSliderTheme {
  const TSliderTheme._();

  static const SliderThemeData lightSliderTheme = SliderThemeData(
    thumbColor: primaryColor,
    activeTrackColor: primaryColor,
    valueIndicatorColor: primaryColor,
    valueIndicatorTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    inactiveTrackColor: Colors.grey,
  );

  static const SliderThemeData darkSliderTheme = SliderThemeData(
    thumbColor: primaryLight,
    activeTrackColor: primaryLight,
    valueIndicatorColor: primaryLight,
    valueIndicatorTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    inactiveTrackColor: Colors.grey,
  );
}
