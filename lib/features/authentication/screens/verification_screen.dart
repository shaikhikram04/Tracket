import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/common/widgets/text/background_text.dart';
import 'package:tracket/features/authentication/models/verification_steps_data.dart';
import 'package:tracket/features/authentication/providers/verification_step.dart';
import 'package:tracket/features/authentication/widgets/verification_widgets/resend_verification_email_button.dart';
import 'package:tracket/features/authentication/widgets/verification_widgets/verification_step_indicator.dart';
import 'package:tracket/features/authentication/widgets/verification_widgets/verification_title.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/devices/devices_utility.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

//* Screen that shows the email verification progress
//* Displays a step indicator with three stages: email sent, verified, and logged in
class VerificationScreen extends ConsumerWidget {
  const VerificationScreen(this.email, {super.key});
  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentStep = ref.watch(verificationStepProvider);
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    final dialogWidth = screenWidth * 0.97;
    final isDark = THelperFunction.isDarkMode(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        final shouldLeave = await THelperFunction.showConfirmationDialog(
          context,
          title: TTextStrings.confirmExit,
          message: TTextStrings.confirmExitMessage,
          cancelText: TTextStrings.stayButton,
          confirmText: TTextStrings.leaveButton,
          confirmButtonBgColor: InteractiveColors.inputError,
        );

        if (shouldLeave && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Dialog(
        backgroundColor: isDark ? DarkThemeColors.cardColor : LightThemeColors.cardColor,
        child: Container(
          width: dialogWidth,
          padding: TPadding.dialogPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: TSizes.xs),
              const VerificationTitle(),
              const SizedBox(height: TSizes.defaultSpace),
              VerificationStepIndicator(currentStep: currentStep),
              const SizedBox(height: TSizes.defaultSpace),
              BackgroundText(
                text: VerificationStepData.getMessage(currentStep, email),
                icon: VerificationStepData.getIconForStep(currentStep),
                iconColor: currentStep != 0 ? primaryColor : null,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              const ResendVerificationEmailButton(),
            ],
          ),
        ),
      ),
    );
  }
}
