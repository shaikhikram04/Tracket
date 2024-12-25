import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    required this.text,
  });

  final void Function() onPressed;
  final bool isLoading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: Theme.of(context).elevatedButtonTheme.style,
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.all(5),
              child: CircularProgressIndicator(color: blackColor),
            )
          : Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
    );
  }
}
