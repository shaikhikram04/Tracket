import 'package:flutter/material.dart';

class MyTextStyle {
  MyTextStyle(this.context);

  BuildContext context;

  TextTheme get textTheme => Theme.of(context).textTheme;

  TextStyle get getTitleLarge {
    return textTheme.titleLarge!;
  }

  TextStyle get getBodyLarge {
    return textTheme.bodyLarge!;
  }
}
