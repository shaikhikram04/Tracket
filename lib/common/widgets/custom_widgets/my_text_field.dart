import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.onSave,
    this.hintText,
    this.isLogin = false,
    this.changeVisibility,
    this.isPasswordHidden = false,
    this.borderRadius = 5,
    this.initialText,
    this.maxLength,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.fillColor,
    this.prefixIcon,
    this.primaryColor = grassGreen,
    this.label,
  });

  final void Function(String? value) onSave;
  final bool isPasswordHidden;
  final String? hintText;
  final String? label;
  final void Function()? changeVisibility;
  final double borderRadius;
  final bool isLogin;
  final String? initialText;
  final int? maxLength;
  final String? Function(String? value)? validator;
  final int maxLines;
  final int? minLines;
  final AutovalidateMode? autovalidateMode;
  final Color? fillColor;
  final IconData? prefixIcon;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    final isEmail = hintText == "Email";
    final isPassword = hintText == 'Password';

    return TextFormField(
      initialValue: initialText,
      obscureText: isPasswordHidden,
      obscuringCharacter: '*',
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      autocorrect: false,
      // style: Theme.of(context).textTheme.bodyLarge,
      maxLines: maxLines,
      minLines: minLines,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: isPassword
            ? IconButton(
                onPressed: changeVisibility,
                icon: Icon(
                  isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
        labelText: label,
        // fillColor: fillColor,
        // filled: fillColor != null,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      maxLength: maxLength,
      onSaved: onSave,
      validator: validator,
    );
  }
}
