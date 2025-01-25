import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';

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
          ? getCircleLoadingIndicator(color: blackColor)
          : Text(
              text,
              style: isSubmit
                  ? MyTextStyle(context).submitBtnTextStyle
                  : MyTextStyle(context).buttonBodyLarge(secondaryColor),
              textAlign: TextAlign.center,
            ),
    );
  }

  static ElevatedButton secondaryElevatedButton(
    BuildContext context, {
    required String text,
    required Function()? onPressed,
    Color primaryColor = Colors.red,
    Color secondaryColor = Colors.white,
    bool isLoading = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        side: BorderSide(color: primaryColor, width: 1.5),
        disabledBackgroundColor: secondaryColor,
      ),
      child: isLoading
          ? getCircleLoadingIndicator(color: primaryColor)
          : Text(
              text,
              style: MyTextStyle(context).buttonBodyLarge(primaryColor),
              textAlign: TextAlign.center,
            ),
    );
  }
}
