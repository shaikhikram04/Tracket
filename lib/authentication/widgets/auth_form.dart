import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({
    super.key,
    required this.child,
    required this.formKey,
  });

  final Widget child;
  final Key formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: child,
      ),
    );
  }
}
