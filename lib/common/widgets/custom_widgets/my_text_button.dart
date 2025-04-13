import 'package:flutter/material.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

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
        style: MyTextStyle(context).bodyLarge.copyWith(
              decoration: isUnderlined ? TextDecoration.underline : null,
              color: Colors.black,
            ),
      ),
    );
  }
}
