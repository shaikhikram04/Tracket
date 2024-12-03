import 'package:flutter/material.dart';
import 'package:tracket/screens/authentication/verification_screen.dart';

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
      ),
    ),
  );
}

void showVerificationDialog(BuildContext context ,String email) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return VerificationScreen(email);
      },
    );
  }
