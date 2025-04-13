import 'package:flutter/material.dart';
import 'package:tracket/features/authentication/widgets/step_circle.dart';
import 'package:tracket/features/authentication/widgets/step_label.dart';

class ProgressStepIndicator extends StatelessWidget {
  final int step;
  final int currentStep;
  final String label;

  const ProgressStepIndicator({
    required this.step,
    required this.currentStep,
    required this.label,
    super.key,
  });

  static const double _spacing = 8.0;

  @override
  Widget build(BuildContext context) {
    final isActive = currentStep >= step;
    return Column(
      children: [
        StepCircle(
          step: step,
          isActive: isActive,
        ),
        const SizedBox(height: _spacing),
        StepLabel(
          label: label,
          isActive: isActive,
        ),
      ],
    );
  }
}
