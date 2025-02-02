import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/widgets/highlighted_label.dart';

class MatchHeader extends StatelessWidget {
  const MatchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '1st Feb 2025',
          style: MyTextStyle(context).bodyMedium,
        ),
        HighlightedLabel(
          text: 'LIVE',
          bgColor: greenColor.withOpacity(0.1),
          textColor: greenColor,
          isLabel: false,
        ),
      ],
    );
  }
}
