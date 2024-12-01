import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class VerificationScreen extends StatelessWidget {
  final int currentStep;

  const VerificationScreen({
    super.key,
    this.currentStep = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Email verification',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
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
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 20),
        ],
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
