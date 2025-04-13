import 'package:flutter/material.dart';

class VerificationStepData {
  static const int sendEmail = 1;
  static const int verified = 2;
  static const int login = 3;

  static String getMessage(int step, String email) {
    switch (step) {
      case 0:
        return 'Wait for email verification';
      case sendEmail:
        return 'Verification email sent to $email! Please check your inbox.';
      case verified:
        return 'Verification email successfully!';
      case login:
        return 'Login successful!';
      default:
        return 'Verification failed. Please try again';
    }
  }

  static IconData getIconForStep(int step) {
    switch (step) {
      case 0:
        return Icons.email_outlined;
      case sendEmail:
        return Icons.check_circle_outline_outlined;
      case verified:
        return Icons.login_outlined;
      default:
        return Icons.circle_outlined;
    }
  }
}
