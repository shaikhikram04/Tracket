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
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: isLabel
            ? MyTextStyle(context).coloredLabelLarge(textColor)
            : MyTextStyle(context)
                .coloredBodyMedium(textColor)
                .copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
