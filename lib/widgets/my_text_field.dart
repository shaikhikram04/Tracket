import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.textController,
    this.isEmail = false,
    this.isPassword = false,
    this.isPasswordHidden = false,
    required this.label,
    this.onPressed,
  });

  final TextEditingController textController;
  final bool isEmail;
  final bool isPassword;
  final bool isPasswordHidden;
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
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
                onPressed: onPressed,
                icon: Icon(
                  isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
