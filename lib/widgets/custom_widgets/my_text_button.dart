import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isUnderlined = false,
  });
  final String text;
  final bool isUnderlined;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              decoration: isUnderlined ? TextDecoration.underline : null,
              color: Colors.black,
            ),
      ),
    );
  }
}
