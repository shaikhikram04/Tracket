import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.textController,
    required this.label,
    this.changeVisibility,
    this.isPasswordHidden = false,
    this.borderRadius = 5,
  });

  final TextEditingController textController;
  final bool isPasswordHidden;
  final String label;
  final void Function()? changeVisibility;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isEmail = label == "Email";
    final isPassword = label == 'Password';

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

    String? passwordValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Password cannot be empty';
      }
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

    return TextFormField(
      controller: textController,
      obscureText: isPasswordHidden,
      obscuringCharacter: '*',
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      autocorrect: false,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
                onPressed: changeVisibility,
                icon: Icon(
                  isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
        labelText: label,
        errorMaxLines: 2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: blackColor),
        ),
      ),
      validator: isEmail
          ? emailValidator
          : isPassword
              ? passwordValidator
              : (value) {
                  if (value == null || value.isEmpty) {
                    return '$label cannot be empty';
                  }

                  if (label == 'Username' && value.trim().contains(' ')) {
                    return '$label cannot contain a space';
                  }
                  if (value.trim().length < 4) {
                    return '$label must contain at least 4 character';
                  }

                  return null;
                },
    );
  }
}
