import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tracket/features/authentication/screens/verification_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class THelperFunction {
  static Color? getColor(String value) {
    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Purple') {
      return Colors.purple;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else if (value == 'Yellow') {
      return Colors.yellow;
    } else if (value == 'Orange') {
      return Colors.orange;
    } else if (value == 'Brown') {
      return Colors.brown;
    } else if (value == 'Teal') {
      return Colors.teal;
    } else if (value == 'Indigo') {
      return Colors.indigo;
    } else {
      return null;
    }
  }

  static void showSnackBar(
    String content,
    BuildContext context, {
    bool isUndo = false,
    void Function()? onUndo,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryColor,
        content: Text(
          content,
          style: MyTextStyle(context).titleMedium.copyWith(color: onPrimary),
        ),
        action: isUndo
            ? SnackBarAction(
                label: 'Undo',
                onPressed: onUndo!,
                backgroundColor: Colors.grey[200],
                textColor: LightThemeColors.primaryText,
              )
            : null,
      ),
    );
  }

  static void showVerificationDialog(BuildContext context, String email) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return VerificationScreen(email);
      },
    );
  }

  static void showIconAlertDialog(
    BuildContext context, {
    required String title,
    required String errorMessage,
    required IconData icon,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 110,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: StatusColors.error.withValues(alpha: 0.8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 45,
                        color: LightThemeColors.surfaceColor,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: MyTextStyle(context).titleMedium.copyWith(
                              color: LightThemeColors.surfaceColor,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    errorMessage,
                    style: MyTextStyle(context).bodyLarge.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'OK',
                          style: MyTextStyle(context).bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: grassGreen,
                              ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static void showAlertDialog(
      BuildContext context, String title, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          backgroundColor: Colors.white,
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showAlertDoubleBtnDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String sureButtonText,
    required Function() onSureButtonPressed,
    String secondaryButtonText = 'Cancel',
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text(secondaryButtonText),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                onSureButtonPressed();
              },
              child: Text(
                sureButtonText,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    }
    return null;
  }

  static Future<String?> pickImageFromGalleryPath() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return file.path;
    }
    return null;
  }

  static List<String> enumToString(List<Enum> enums) {
    return enums
        .map(
          (e) => e.name,
        )
        .toList();
  }

  static List<String> matchFormatToString() {
    return const [
      TTextStrings.over5,
      TTextStrings.over10,
      TTextStrings.over20,
      TTextStrings.over50,
      TTextStrings.test,
    ];
  }

  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'Email-is-already-in-use-as-user':
        return TTextStrings.emailUsedByUser;
      case 'Email-is-already-in-use-as-player':
        return TTextStrings.emailUsedByPlayer;
      default:
        return TTextStrings.unexpectedError;
    }
  }

  static Text getTitleText(String title, BuildContext context) {
    return Text(
      title,
      style: MyTextStyle(context).titleLarge,
    );
  }

  static void pushScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  static Widget getCircleLoadingIndicator({
    double strokeWidth = TSizes.loadingStrokeWidthLg,
    Color? color,
    double? dimension,
    Animation<Color?>? valueColor,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox.square(
          dimension: dimension,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            color: color,
            valueColor: valueColor,
          ),
        ),
      ),
    );
  }

  static String timeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays >= 356) {
      final int year = (difference.inDays / 365).floor();
      return '${year} y ago';
    } else if (difference.inDays >= 30) {
      final int month = (difference.inDays / 30).floor();
      return '${month} month ago';
    } else if (difference.inDays >= 7) {
      final int week = (difference.inDays / 7).floor();
      return '${week} w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    }

    return 'just now';
  }

  static Future<void> showLoadingDialog(BuildContext context,
      {String? message}) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getCircleLoadingIndicator(),
              const SizedBox(height: 10),
              if (message != null)
                Text(
                  message,
                  style: MyTextStyle(context).bodyLarge.copyWith(
                        color: LightThemeColors.primaryText,
                      ),
                ),
            ],
          ),
        );
      },
    );
  }

  static String truncateText(String text, int maxLine) {
    if (text.length <= maxLine) {
      return text;
    } else {
      return '${text.substring(0, maxLine)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double screenHeight(BuildContext context) {
    return screenSize(context).height;
  }

  static double screenWidth(BuildContext context) {
    return screenSize(context).width;
  }

  static String getFormattedDate(DateTime date,
      {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];

    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }

    return wrappedList;
  }
}
