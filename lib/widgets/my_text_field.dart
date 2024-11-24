import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.textController,
      required this.isEmail,
      required this.isPassword,
      required this.isPasswordVisible,
      required this.label});

  final TextEditingController textController;
  final bool isEmail;
  final bool isPassword;
  final bool isPasswordVisible;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      autocorrect: false,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
