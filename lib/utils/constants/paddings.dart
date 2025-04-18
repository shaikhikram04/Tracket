import 'package:flutter/widgets.dart';

class TPadding {
  //* horizontal padding
  static const hPaddingMd = EdgeInsets.symmetric(horizontal: 20);
  static const hPaddingXl = EdgeInsets.symmetric(horizontal: 24);

  //* vertical padding
  static const vPaddingSm = EdgeInsets.symmetric(vertical: 8);
  static const vPaddingMd = EdgeInsets.symmetric(vertical: 12);
  static const vPaddingLg = EdgeInsets.symmetric(vertical: 16);
  static const vPaddingXl = EdgeInsets.symmetric(vertical: 20);

  //* all padding
  static const xs = EdgeInsets.all(8);
  static const sm = EdgeInsets.all(12);
  static const md = EdgeInsets.all(16);
  static const lg = EdgeInsets.all(20);
  static const xl = EdgeInsets.all(24);

  //* dialog padding
  static const dialogPadding =
      EdgeInsets.symmetric(horizontal: 30, vertical: 20);

  //* button padding
  static const buttonPaddingSm = EdgeInsets.symmetric(horizontal: 10);

  //* symmetric padding
  static const paddingSm = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const paddingMd = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const paddingLg = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static const paddingXl = EdgeInsets.symmetric(horizontal: 24, vertical: 12);

  //* card padding
  static const cardPaddingSm = EdgeInsets.symmetric(vertical: 25, horizontal: 20);
}
