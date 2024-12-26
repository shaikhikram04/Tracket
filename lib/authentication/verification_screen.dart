import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/provider/verification_step.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';

class VerificationScreen extends ConsumerWidget {
  const VerificationScreen(this.email, {super.key});
  final String email;

  String getMessage(int step) {
    String message;

    switch (step) {
      case 0:
        message = 'Wait for email verification';
        break;
      case 1:
        message = 'Verification email sent to $email! Please check your inbox.';
        break;
      case 2:
        message = 'Verification email successfully!';
        break;
      case 3:
        message = 'Login successful!';
        break;
      default:
        message = 'Verification failed. Please try again';
    }

    return message;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentStep = ref.watch(verificationStepProvider);
    final double width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        showSnackBar(
          'Please wait until verification done, otherwise verification failed!',
          context,
        );
      },
      child: Dialog(
        backgroundColor: Colors.white,
        child: SizedBox(
          width: width * 0.95,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                Text(
                  'Email verification',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProgressStep(
                      step: 1,
                      currentStep: currentStep,
                      label: 'Send Email',
                    ),
                    _buildProgressLine(isActive: currentStep > 1),
                    _buildProgressStep(
                      step: 2,
                      currentStep: currentStep,
                      label: 'Verified',
                    ),
                    _buildProgressLine(isActive: currentStep > 2),
                    _buildProgressStep(
                      step: 3,
                      currentStep: currentStep,
                      label: 'Login',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  getMessage(currentStep),
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStep({
    required int step,
    required int currentStep,
    required String label,
  }) {
    bool isActive = currentStep >= step;
    return Column(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.green : Colors.grey.shade300,
            border: Border.all(
              color: isActive ? Colors.green : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              _getIconForStep(step),
              color: isActive ? Colors.white : Colors.grey.shade600,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? greenColor : Colors.grey.shade600,
            fontSize: 12,
          ),
        )
      ],
    );
  }

  Widget _buildProgressLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? greenColor : Colors.grey[350],
      ),
    );
  }

  IconData _getIconForStep(int step) {
    switch (step) {
      case 0:
        return Icons.email_outlined;
      case 1:
        return Icons.check_circle_outline;
      case 2:
        return Icons.login_outlined;
      default:
        return Icons.circle_outlined;
    }
  }
}
