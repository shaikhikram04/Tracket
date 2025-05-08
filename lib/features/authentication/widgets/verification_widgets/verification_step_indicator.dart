import 'package:flutter/material.dart';
import 'package:tracket/features/authentication/widgets/verification_widgets/progress_step_indicator.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';

class VerificationStepIndicator extends StatelessWidget {
  const VerificationStepIndicator({super.key, required this.currentStep});

  final int currentStep;

  Widget _buildProgressLine({
    required bool isActive,
  }) {
    return Expanded(child: Container(height: TSizes.dividerHeight, color: isActive ? primaryColor : Colors.grey[350]));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProgressStepIndicator(step: 1, currentStep: currentStep, label: TTextStrings.sendEmail),
        _buildProgressLine(isActive: currentStep > 1),
        ProgressStepIndicator(step: 2, currentStep: currentStep, label: TTextStrings.verified),
        _buildProgressLine(isActive: currentStep > 2),
        ProgressStepIndicator(step: 3, currentStep: currentStep, label: TTextStrings.login),
      ],
    );
  }
}
