import 'package:flutter/material.dart';

class StatNumber extends StatelessWidget {
  const StatNumber({
    required this.number,
    required this.style,
    this.prefix,
    this.suffix,
  });

  final int number;
  final TextStyle style;
  final String? prefix;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${prefix ?? ''}$number${suffix ?? ''}',
      style: style,
    );
  }
}
