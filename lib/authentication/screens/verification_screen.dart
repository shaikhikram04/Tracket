import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/authentication/models/verification_steps_data.dart';
import 'package:tracket/authentication/providers/verification_step.dart';
import 'package:tracket/authentication/widgets/progress_step_indicator.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';

//* Screen that shows the email verification progress
//* Displays a step indicator with three stages: email sent, verified, and logged in
class VerificationScreen extends ConsumerWidget {
  //* Creates a verification screen for the given email address
  const VerificationScreen(this.email, {super.key});
  //* Email address to which verification email is sent
  final String email;

  static const double _horizontalPadding = 30.0;
  static const double _verticalPadding = 20.0;
  static const double _lineHeight = 2.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentStep = ref.watch(verificationStepProvider);
    final double width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        //* Consider adding a confirmation dialog
        showAlertDoubleBtnDialog(
          context,
          title: 'Confirm Exit',
          content:
              'Leaving now will cancel the verification process. Are you sure?',
          sureButtonText: 'Leave',
          onSureButtonPressed: () => Navigator.of(context).pop(),
          secondaryButtonText: 'Stay',
        );
      },
      child: Dialog(
        backgroundColor: Colors.white,
        child: SizedBox(
          width: width * 0.95,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _horizontalPadding,
              vertical: _verticalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                Text(
                  'Email verification',
                  style: MyTextStyle(context).titleLarge,
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProgressStepIndicator(
                      step: 1,
                      currentStep: currentStep,
                      label: 'Send Email',
                    ),
                    _buildProgressLine(isActive: currentStep > 1),
                    ProgressStepIndicator(
                      step: 2,
                      currentStep: currentStep,
                      label: 'Verified',
                    ),
                    _buildProgressLine(isActive: currentStep > 2),
                    ProgressStepIndicator(
                      step: 3,
                      currentStep: currentStep,
                      label: 'Login',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  VerificationStepData.getMessage(currentStep, email),
                  style: MyTextStyle(context).bodyLarge,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressLine({
    required bool isActive,
  }) {
    return Expanded(
      child: Container(
        height: _lineHeight,
        color: isActive ? primaryColor : Colors.grey[350],
      ),
    );
  }
}
