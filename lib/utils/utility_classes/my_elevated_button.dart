import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class MyElevatedButton {
  static ElevatedButton primaryElevatedButton(
    BuildContext context, {
    required void Function()? onPressed,
    required String text,
    bool isSubmit = false,
    bool isLoading = false,
    Color primaryColor = greenColor,
    Color secondaryColor = whiteColor,
    Color disabledColor = greenColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        disabledBackgroundColor: disabledColor,
      ),
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.all(5),
              child: CircularProgressIndicator(color: blackColor),
            )
          : Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: isSubmit ? FontWeight.bold : FontWeight.w500,
                    fontSize: isSubmit ? 18 : 14,
                    color: isSubmit ? blackColor : secondaryColor,
                  ),
            ),
    );
  }

  static ElevatedButton secondaryElevatedButton(
    BuildContext context, {
    required String text,
    required Function() onPressed,
    Color primaryColor = Colors.red,
    Color secondaryColor = Colors.white,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        side: BorderSide(color: primaryColor, width: 1.5),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
      ),
    );
  }
}
