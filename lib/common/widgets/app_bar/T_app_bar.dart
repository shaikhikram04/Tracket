import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';

class TAppBar {
  /// Builds the app bar with title and notification icon
  static PreferredSizeWidget primaryAppBar(String title, List<Widget> actions) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: onPrimary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      actions: actions,
    );
  }
}
