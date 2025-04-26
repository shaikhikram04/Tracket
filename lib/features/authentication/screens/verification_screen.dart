import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/authentication/models/verification_steps_data.dart';
import 'package:tracket/features/authentication/providers/verification_step.dart';
import 'package:tracket/features/authentication/widgets/progress_step_indicator.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/devices/devices_utility.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';

//* Screen that shows the email verification progress
//* Displays a step indicator with three stages: email sent, verified, and logged in
class VerificationScreen extends ConsumerWidget {
  //* Creates a verification screen for the given email address
  const VerificationScreen(this.email, {super.key});
  //* Email address to which verification email is sent
  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentStep = ref.watch(verificationStepProvider);
    final double width = TDeviceUtils.getScreenWidth(context);

    final isDark = THelperFunction.isDarkMode(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        //* Consider adding a confirmation dialog
        final wantToStay = await THelperFunction.showConfirmationDialog(
          context,
          title: TTextStrings.confirmExit,
          message: TTextStrings.confirmExitMessage,
          cancelText: TTextStrings.leaveButton,
          confirmText: TTextStrings.stayButton,
          confirmButtonBgColor: primaryColor,
        );
        if (wantToStay) {
          // Handle the case when the user wants to stay
          Navigator.of(context).pop();
          return;
        }
      },
      child: Dialog(
        backgroundColor:
            isDark ? DarkThemeColors.cardColor : LightThemeColors.cardColor,
        child: SizedBox(
          width: width * 0.97,
          child: Padding(
            padding: TPadding.dialogPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: TSizes.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: TSizes.sm,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: isDark ? primaryLight : primaryVariant,
                      size: TSizes.iconMd,
                    ),
                    Text(
                      TTextStrings.authentication,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? primaryLight : primaryVariant,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.defaultSpace),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProgressStepIndicator(
                      step: 1,
                      currentStep: currentStep,
                      label: TTextStrings.sendEmail,
                    ),
                    _buildProgressLine(isActive: currentStep > 1),
                    ProgressStepIndicator(
                      step: 2,
                      currentStep: currentStep,
                      label: TTextStrings.verified,
                    ),
                    _buildProgressLine(isActive: currentStep > 2),
                    ProgressStepIndicator(
                      step: 3,
                      currentStep: currentStep,
                      label: TTextStrings.login,
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.defaultSpace),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Icon(
                        VerificationStepData.getIconForStep(currentStep),
                        color: currentStep != 0 ? primaryColor : null,
                      ),
                      Expanded(
                        child: Text(
                          VerificationStepData.getMessage(currentStep, email),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    height: 1.5,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: TPadding.xs,
                    decoration: BoxDecoration(
                      color: isDark ? primaryLight : primaryVariant,
                      borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        const Icon(
                          AppIconData.email,
                          color: LightThemeColors.surfaceColor,
                        ),
                        Flexible(
                          child: Text(
                            TTextStrings.resendVerificationEmail,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: LightThemeColors.surfaceColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
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
        height: TSizes.dividerHeight,
        color: isActive ? primaryColor : Colors.grey[350],
      ),
    );
  }
}
