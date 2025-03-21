import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/authentication/models/verification_steps_data.dart';
import 'package:tracket/authentication/widgets/progress_step_indicator.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';

//* Screen that shows the email verification progress
//* Displays a step indicator with three stages: email sent, verified, and logged in
class VerificationScreen extends ConsumerWidget {
  //* Creates a verification screen for the given email address
  const VerificationScreen(this.email, {super.key});
  //* Email address to which verification email is sent
  final String email;

  static const double _lineHeight = 2.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentStep = 0; // ref.watch(verificationStepProvider);
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
          width: width * 0.97,
          child: Padding(
            padding: AppPadding.dialogPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      color: primaryVariant,
                      size: 25,
                    ),
                    Text(
                      'Authentication',
                      style: MyTextStyle(context).titleLarge.copyWith(
                            fontWeight: FontWeight.w800,
                            color: primaryVariant,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
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
                      label: 'Verixfied',
                    ),
                    _buildProgressLine(isActive: currentStep > 2),
                    ProgressStepIndicator(
                      step: 3,
                      currentStep: currentStep,
                      label: 'Login',
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Icon(
                        VerificationStepData.getIconForStep(currentStep),
                        color: currentStep != 0 ? primaryColor : null,
                      ),
                      Expanded(
                        child: Text(
                          VerificationStepData.getMessage(currentStep, email),
                          style: MyTextStyle(context).bodyMedium.copyWith(
                                color: LightThemeColors.secondaryText,
                                height: 1.5,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        const Icon(
                          AppIconData.email,
                          color: LightThemeColors.surfaceColor,
                        ),
                        Text(
                          'Resend Verification Email',
                          style: MyTextStyle(context).titleSmall.copyWith(
                              color: LightThemeColors.surfaceColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
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
