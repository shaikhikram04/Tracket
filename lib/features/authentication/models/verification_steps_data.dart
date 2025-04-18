import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/text_strings.dart';

class VerificationStepData {
  static const int sendEmail = 1;
  static const int verified = 2;
  static const int login = 3;

  static String getMessage(int step, String email) {
    switch (step) {
      case 0:
        return TTextStrings.waitForEmailVerification;
      case sendEmail:
        return TTextStrings.resetEmailSentMsg(email);
      case verified:
        return TTextStrings.emailVerificationSuccessfully;
      case login:
        return TTextStrings.loginSuccessfully;
      default:
        return TTextStrings.emailVerificationFailed;
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
