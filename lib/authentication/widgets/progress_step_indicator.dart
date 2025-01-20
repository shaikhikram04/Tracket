import 'package:flutter/material.dart';

class ProgressStepIndicator extends StatelessWidget {
  final int step;
  final int currentStep;
  final String label;

  const ProgressStepIndicator({
    required this.step,
    required this.currentStep,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isActive = currentStep >= step;
    return Column(
      children: [
        StepCircle(
          step: step,
          isActive: isActive,
        ),
        const SizedBox(height: 8),
        StepLabel(
          label: label,
          isActive: isActive,
        ),
      ],
    );
  }
}