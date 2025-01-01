import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class MySmallElevatedButton extends StatelessWidget {
  const MySmallElevatedButton({
    super.key,
    required this.isAdded,
    required this.onPressed,
    required this.isLoading,
    required this.buttonText,
  });

  final bool isAdded;
  final void Function() onPressed;
  final bool isLoading;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isAdded ? Colors.grey : buttonBgColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        fixedSize: const Size(95, 35),
      ),
      onPressed: (isAdded || isLoading) ? null : onPressed,
      child: isLoading
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          : Text(
              buttonText,
              style: const TextStyle(color: blackColor),
            ),
    );
  }
}
