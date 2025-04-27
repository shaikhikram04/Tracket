import 'package:flutter/material.dart';

class StatLabel extends StatelessWidget {
  const StatLabel({
    super.key,
    required this.label,
    required this.labelStyle,
    required this.labelColor,
    required this.defaultLabelStyle,
    required this.theme,
  });

  final String label;
  final TextStyle? labelStyle;
  final Color? labelColor;
  final TextStyle defaultLabelStyle;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: labelStyle?.copyWith(color: labelColor) ??
          defaultLabelStyle.copyWith(
            color: labelColor ??
                theme.textTheme.titleSmall?.color?.withValues(alpha: 0.7),
          ),
      textAlign: TextAlign.center,
    );
  }
}
