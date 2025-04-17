import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/theme/custom_theme/text_theme.dart';

class TAppBarTheme {
  const TAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Colors.black, size: TSizes.iconMd),
    titleTextStyle: TTextTheme.lightTextTheme.headlineSmall,
    actionsIconTheme:
        const IconThemeData(color: Colors.black, size: TSizes.iconMd),
  );

  static AppBarTheme darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Colors.black, size: 24),
    titleTextStyle: TTextTheme.darkTextTheme.headlineSmall,
    actionsIconTheme: const IconThemeData(color: Colors.white, size: 24),
  );
}
