import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.onSave,
    required this.label,
    this.isLogin = false,
    this.changeVisibility,
    this.isPasswordHidden = false,
    this.borderRadius = 5,
    this.initialText,
    this.maxLength,
    this.validator,
    this.maxLines = 1,
    this.minLines = null,
  });

  final void Function(String? value) onSave;
  final bool isPasswordHidden;
  final String label;
  final void Function()? changeVisibility;
  final double borderRadius;
  final bool isLogin;
  final String? initialText;
  final int? maxLength;
  final String? Function(String? value)? validator;
  final int maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    final isEmail = label == "Email";
    final isPassword = label == 'Password';

    return TextFormField(
      initialValue: initialText,
      obscureText: isPasswordHidden,
      obscuringCharacter: '*',
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      autocorrect: false,
      style: Theme.of(context).textTheme.bodyLarge,
      maxLines: maxLines,
      minLines: minLines,
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
      maxLength: maxLength,
      onSaved: onSave,
      validator: validator,
    );
  }
}
