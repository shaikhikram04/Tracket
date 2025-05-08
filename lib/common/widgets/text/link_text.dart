import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';

class LinkText extends StatelessWidget {
  const LinkText({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor = onPrimary,
  });

  final String text;
  final VoidCallback onTap;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: textColor,
              fontStyle: FontStyle.italic,
              letterSpacing: 1,
              decoration: TextDecoration.underline,
              decorationColor: textColor,
            ),
      ),
    );
  }
}
