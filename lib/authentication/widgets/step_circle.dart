import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class StepCircle extends StatelessWidget {
  const StepCircle({
    super.key,
    required this.isActive,
    required this.step,
  });

  final bool isActive;
  final int step;

  static const double _stepCircleSize = 50.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _stepCircleSize,
      height: _stepCircleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.green : Colors.grey.shade300,
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: MyTextStyle(context)
              .bodyLarge
              .copyWith(color: isActive ? onPrimaryColor : primaryTextColor),
        ),
      ),
    );
  }
}
