import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';

class TTabBarTheme {
  const TTabBarTheme._();

  static const TabBarTheme light = TabBarTheme(
    labelColor: primaryColor,
    unselectedLabelColor: Colors.black54,
    indicatorSize: TabBarIndicatorSize.label,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: primaryColor,
        width: 2.0,
      ),
    ),
    labelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    labelPadding: EdgeInsets.symmetric(
      horizontal: 16,
    ),
  );

  static const TabBarTheme dark = TabBarTheme(
    labelColor: primaryLight,
    unselectedLabelColor: Colors.white54,
    indicatorSize: TabBarIndicatorSize.label,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: primaryLight,
        width: 2.0,
      ),
    ),
    labelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelPadding: EdgeInsets.symmetric(
      horizontal: 16,
    ),
  );
}
