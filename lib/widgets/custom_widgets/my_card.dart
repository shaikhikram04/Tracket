import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class MyCard extends StatelessWidget {
  const MyCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: LightThemeColors.surfaceColor,
      elevation: 7,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: child,
      ),
    );
  }
}
