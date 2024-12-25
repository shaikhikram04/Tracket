import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/screens/authentication/verification_screen.dart';
import 'package:tracket/utils/colors.dart';

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: greenColor,
      content: Text(
        content,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ),
  );
}

void showVerificationDialog(BuildContext context, String email) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return VerificationScreen(email);
    },
  );
}

void showAlertDialog(BuildContext context, String title, String errorMessage) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        backgroundColor: Colors.white,
        content: Text(errorMessage),
      );
    },
  );
}

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
  return null;
}

List<String> enumToString(List<Enum> enums) {
  return enums
      .map(
        (e) => e.name,
      )
      .toList();
}
