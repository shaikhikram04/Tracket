import 'package:flutter/widgets.dart';

class TPadding {
  const TPadding._();
  //* horizontal padding
  static const hPaddingXxs = EdgeInsets.symmetric(horizontal: 2);
  static const hPaddingXxsSm = EdgeInsets.symmetric(horizontal: 4);
  static const hPaddingXs = EdgeInsets.symmetric(horizontal: 8);
  static const hPaddingSm = EdgeInsets.symmetric(horizontal: 12);
  static const hPaddingMd = EdgeInsets.symmetric(horizontal: 16);
  static const hPaddingLg = EdgeInsets.symmetric(horizontal: 20);
  static const hPaddingXl = EdgeInsets.symmetric(horizontal: 24);

  //* vertical padding
  static const vPaddingXxs = EdgeInsets.symmetric(vertical: 2);
  static const vPaddingXs = EdgeInsets.symmetric(vertical: 4);
  static const vPaddingSm = EdgeInsets.symmetric(vertical: 8);
  static const vPaddingMd = EdgeInsets.symmetric(vertical: 12);
  static const vPaddingLg = EdgeInsets.symmetric(vertical: 16);
  static const vPaddingXl = EdgeInsets.symmetric(vertical: 20);

  //* all padding
  static const xxs = EdgeInsets.all(4);
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
  static const paddingXs = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  static const paddingMd = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const paddingLg = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static const paddingXl = EdgeInsets.symmetric(horizontal: 24, vertical: 12);

  //* card padding
  static const cardPaddingXs = EdgeInsets.symmetric(vertical: 6, horizontal: 4);
  static const cardPaddingLg =
      EdgeInsets.symmetric(vertical: 25, horizontal: 18);

  static const profileHeader =
      EdgeInsets.symmetric(vertical: 10, horizontal: 15);

  //* list tile padding
  static const listTilePadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const listTilePaddingSm =
      EdgeInsets.symmetric(horizontal: 16, vertical: 4);
}
