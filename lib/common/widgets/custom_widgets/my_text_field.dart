import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.onSave,
    this.hintText,
    this.changeVisibility,
    this.isPasswordHidden = false,
    this.initialText,
    this.maxLength,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.prefixIcon,
    this.label,
  });

  final void Function(String? value) onSave;
  final bool isPasswordHidden;
  final String? hintText;
  final String? label;
  final void Function()? changeVisibility;
  final String? initialText;
  final int? maxLength;
  final String? Function(String? value)? validator;
  final int maxLines;
  final int? minLines;
  final AutovalidateMode? autovalidateMode;
  final IconData? prefixIcon;

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
      maxLines: maxLines,
      minLines: minLines,
      autovalidateMode: autovalidateMode,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 16,
          ),
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
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      maxLength: maxLength,
      onSaved: onSave,
      validator: validator,
    );
  }
}
