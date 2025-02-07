import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';

class MyElevatedButton {
  static ElevatedButton primaryElevatedButton(
    BuildContext context, {
    required void Function()? onPressed,
    required String text,
    bool isLoading = false,
    Color backgroundColor = primaryColor,
    Color disabledColor = mediumGrey,
    EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 12,
    ),
    double borderRadius = 25,
    TextStyle? textStyle,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        disabledBackgroundColor: disabledColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 2,
      ),
      child: isLoading
          ? getCircleLoadingIndicator(color: blackColor)
          : Text(
              text,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
    );
  }

  static ElevatedButton secondaryElevatedButton(
    BuildContext context, {
    required String text,
    required Function()? onPressed,
    Color primaryColor = errorColor,
    Color secondaryColor = whiteColor,
    bool isLoading = false,
    double fontSize = 14,
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
              style: MyTextStyle(context).titleMedium.copyWith(
                    color: primaryColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
    );
  }

  static ElevatedButton iconTextElevatedButton(
    BuildContext context, {
    required String text,
    required Icon icon,
    required VoidCallback onPressed,
    TextStyle? textStyle,
    Color backgroundColor = darkGreenColor,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 16,
    ),
    double borderRadius = 25,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        text,
        style: textStyle,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
