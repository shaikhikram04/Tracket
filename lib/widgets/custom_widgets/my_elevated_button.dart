import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class MyElevatedButton {
  static ElevatedButton primaryElevatedButton(
    BuildContext context, {
    void Function()? onPressed,
    required String text,
    bool isSubmit = false,
    bool isLoading = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: greenColor,
        disabledBackgroundColor: greenColor,
      ),
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.all(5),
              child: CircularProgressIndicator(color: blackColor),
            )
          : Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: isSubmit ? FontWeight.bold : FontWeight.normal,
                    fontSize: isSubmit ? 18 : null,
                  ),
            ),
    );
  }
}
