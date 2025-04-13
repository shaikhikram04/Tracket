import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

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
    this.primaryColor = const Color(0xFF2E7D32),
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
      style: MyTextStyle(context).bodyLarge,
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
        hintStyle: MyTextStyle(context).bodyLarge.copyWith(
              color: fillColor != null
                  ? LightThemeColors.tertiaryText
                  : primaryColor.withValues(alpha: 0.7),
            ),
        labelText: label,
        fillColor: fillColor,
        filled: fillColor != null,
        errorMaxLines: 2,
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: primaryColor) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      maxLength: maxLength,
      onSaved: onSave,
      validator: validator,
    );
  }
}
