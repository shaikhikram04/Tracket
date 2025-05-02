import 'package:flutter/material.dart';

class StatLabel extends StatelessWidget {
  const StatLabel({
    super.key,
    required this.label,
    required this.labelStyle,
    required this.labelColor,
    required this.defaultLabelStyle,
  });

  final String label;
  final TextStyle? labelStyle;
  final Color? labelColor;
  final TextStyle defaultLabelStyle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Text(
      label,
      style: labelStyle?.copyWith(color: labelColor) ??
          defaultLabelStyle.copyWith(
            color: labelColor ??
                textTheme.titleSmall?.color?.withValues(alpha: 0.7),
          ),
      textAlign: TextAlign.center,
    );
  }
}
