import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/widgets/highlighted_label.dart';

class MatchHeader extends StatelessWidget {
  const MatchHeader({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat.yMMMMd().format(match.createdAt.toDate()),
          style: MyTextStyle(context).bodyMedium,
        ),
        if (match.status == MatchStatus.live)
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
