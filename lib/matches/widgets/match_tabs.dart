import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class MatchTabs extends StatelessWidget {
  const MatchTabs({
    super.key,
    required this.text,
    required this.isSelected,
  });

  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    List<Color> colors = isSelected
        ? [
            greenColor,
            enableButtonColor1,
            greenColor,
          ]
        : [
            disableButtonColor1,
            disableButtonColor2,
            disableButtonColor1,
          ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: SweepGradient(colors: colors),
        border: isSelected ? Border.all(color: blackColor) : null,
      ),
      child: Text(text),
    );
  }
}
