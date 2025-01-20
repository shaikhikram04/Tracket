import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class StepLabel extends StatelessWidget {
  const StepLabel({
    super.key,
    required this.isActive,
    required this.label,
  });

  final bool isActive;
  final String label;

  static const double _labelFontSize = 12.0;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: isActive ? greenColor : Colors.grey.shade600,
        fontSize: _labelFontSize,
      ),
    );
  }
}
