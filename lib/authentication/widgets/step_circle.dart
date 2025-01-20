import 'package:flutter/material.dart';
import 'package:tracket/authentication/models/verification_steps_data.dart';

class StepCircle extends StatelessWidget {
  const StepCircle({
    super.key,
    required this.isActive,
    required this.step,
  });

  final bool isActive;
  final int step;

  static const double _stepCircleSize = 40.0;
  static const double _iconSize = 18.0;

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
      child: Icon(
        VerificationStepData.getIconForStep(step),
        color: isActive ? Colors.white : Colors.grey.shade600,
        size: _iconSize,
        semanticLabel: isActive ? 'Step $step completed' : 'Step $step pending',
      ),
    );
  }
}
