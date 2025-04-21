import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';

class TBottomSheetTheme {
  const TBottomSheetTheme._();

  static BottomSheetThemeData lightBottomSheetTheme =
      const BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(TSizes.borderRadiusXl)),
    ),
    showDragHandle: true,
    backgroundColor: LightThemeColors.secondaryBackground,
    modalBackgroundColor: LightThemeColors.secondaryBackground,
    constraints: BoxConstraints(minWidth: double.infinity),
  );

  static BottomSheetThemeData darkBottomSheetTheme = const BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(TSizes.borderRadiusXl)),
    ),
    showDragHandle: true,
    backgroundColor: DarkThemeColors.secondaryBackground,
    modalBackgroundColor: DarkThemeColors.secondaryBackground,
    constraints: BoxConstraints(minWidth: double.infinity),
  );
}
