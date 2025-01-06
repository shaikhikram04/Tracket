import 'package:flutter/material.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class HighlightedLabel extends StatelessWidget {
  const HighlightedLabel({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
    this.isLabel = true,
  });

  final String text;
  final Color bgColor;
  final Color textColor;
  final bool isLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5, bottom: 5),
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: isLabel
            ? MyTextStyle(context).coloredLabelLarge(textColor)
            : MyTextStyle(context).coloredBodyLarge(textColor),
      ),
    );
  }
}
