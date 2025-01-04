import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracket/authentication/screens/verification_screen.dart';
import 'package:tracket/utils/colors.dart';

void showSnackBar(String content, BuildContext context,
    {bool isUndo = false, void Function()? onUndo}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: greenColor,
      content: Text(
        content,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      action: isUndo
          ? SnackBarAction(
              label: 'Undo',
              onPressed: onUndo!,
              backgroundColor: Colors.grey[200],
              textColor: blackColor,
            )
          : null,
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

void showAlertDialog(BuildContext context, String title, String errorMessage ) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        backgroundColor: Colors.white,
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void showAlertDoubleBtnDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String sureButtonText,
    required Function() onSureButtonPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onSureButtonPressed();
              },
              child: Text(
                sureButtonText,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
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

double getSafeAreaHeight(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  return mediaQuery.size.height -
      mediaQuery.padding.top -
      mediaQuery.padding.bottom;
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email cannot be empty';
  }

  //! Regular expression for validating an email
  const emailRegex = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
  if (!RegExp(emailRegex).hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null; //? Valid email
}

String? passwordValidator(String? value, bool isLogin) {
  if (value == null || value.isEmpty) {
    return 'Password cannot be empty';
  }

  if (isLogin) return null;

  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Password must contain at least one uppercase letter';
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'Password must contain at least one lowercase letter';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Password must contain at least one number';
  }
  if (!RegExp(r'[!@#\$%\^&\*(),.?":{}|<>]').hasMatch(value)) {
    return 'Password must contain at least one special character';
  }
  return null;
}

String? usernameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Username cannot be empty';
  }

  if (value.trim().contains(' ')) {
    return 'Username cannot contain a space';
  }

  if (value.trim().length < 4) {
    return 'Username must contain at least 4 characters';
  }
  return null;
}

String? teamShortNameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Team Short Name cannot be empty';
  }

  if (value.trim().contains(' ')) {
    return 'Team Short Name cannot contain a space';
  }

  if (value.trim().length > 4) {
    return 'Team Short Name must contain at most 4 characters';
  }
  return null;
}

String? nameValidator(String? value, String fieldName) {
  if (value == null || value.isEmpty) {
    return '$fieldName cannot be empty';
  }

  if (value.trim().length < 4) {
    return '$fieldName must contain at least 4 characters';
  }
  return null;
}

String getErrorMessage(String errorCode) {
  switch (errorCode) {
    case 'Email-is-already-in-use-as-user':
      return 'This email is already in use. Try another email or login as a user.';
    case 'Email-is-already-in-use-as-player':
      return 'This email is already in use. Try another email or login as a player.';
    default:
      return 'An unexpected error occurred. Please try again.';
  }
}

Text getTitleText(String title, BuildContext context) {
  return Text(
    title,
    style:
        Theme.of(context).textTheme.titleLarge!.copyWith(color: darkGreenColor),
  );
}

void pushScreen(BuildContext context, Widget screen) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => screen,
    ),
  );
}
