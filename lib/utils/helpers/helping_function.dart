import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/features/authentication/screens/verification_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

//? Helper functions for the Tracket application
class THelperFunction {
  /// Private constructor to prevent instantiation
  THelperFunction._();

  /// Maps color name strings to corresponding Flutter Colors
  static const Map<String, Color> _colorMap = {
    'Green': Colors.green,
    'Red': Colors.red,
    'Blue': Colors.blue,
    'Pink': Colors.pink,
    'Grey': Colors.grey,
    'Purple': Colors.purple,
    'Black': Colors.black,
    'White': Colors.white,
    'Yellow': Colors.yellow,
    'Orange': Colors.orange,
    'Brown': Colors.brown,
    'Teal': Colors.teal,
    'Indigo': Colors.indigo,
  };

  /// Returns a Color object based on the provided color name string
  static Color? getColor(String value) => _colorMap[value];

  static void showSnackBar(
    String content,
    BuildContext context, {
    bool isUndo = false,
    void Function()? onUndo,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final textStyle =
        MyTextStyle(context).titleMedium.copyWith(color: onPrimary);
    final snackBar = SnackBar(
      backgroundColor: primaryColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Text(content, style: textStyle),
      action: isUndo && onUndo != null
          ? SnackBarAction(
              label: 'Undo',
              onPressed: onUndo,
              backgroundColor: Colors.green[50],
              textColor: primaryColor,
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Shows a dialog for email verification
  static void showVerificationDialog(BuildContext context, String email) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => VerificationScreen(email),
    );
  }

  /// Shows an alert dialog with an icon
  static void showIconAlertDialog(
    BuildContext context, {
    required String title,
    required String errorMessage,
    required IconData icon,
    Color iconColor = Colors.white,
    Color headerColor = Colors.red,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        final textStyle = MyTextStyle(context);

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 110,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 48, color: iconColor),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: textStyle.titleMedium.copyWith(
                        color: iconColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  errorMessage,
                  style:
                      textStyle.bodyLarge.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              InkWell(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: textStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Shows a basic alert dialog
  static void showAlertDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: primaryColor)),
            ),
          ],
        );
      },
    );
  }

  /// Picks an image from camera or gallery and returns it as bytes
  static Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file = await imagePicker.pickImage(source: source);

    return file != null ? await file.readAsBytes() : null;
  }

  /// Picks an image from gallery and returns its file path
  static Future<String?> pickImageFromGalleryPath() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file =
        await imagePicker.pickImage(source: ImageSource.gallery);

    return file?.path;
  }

  /// Converts a list of enums to a list of strings
  static List<String> enumToString(List<Enum> enums) {
    return enums.map((e) => e.name).toList();
  }

  /// Returns a list of match format strings
  static List<String> matchFormatToString() {
    return const [
      TTextStrings.over5,
      TTextStrings.over10,
      TTextStrings.over20,
      TTextStrings.over50,
      TTextStrings.test,
    ];
  }

  /// Maps error codes to user-friendly error messages
  static String getErrorMessage(String errorCode) {
    const errorMessages = {
      'Email-is-already-in-use-as-user': TTextStrings.emailUsedByUser,
      'Email-is-already-in-use-as-player': TTextStrings.emailUsedByPlayer,
    };

    return errorMessages[errorCode] ?? TTextStrings.unexpectedError;
  }

  /// Returns a styled Text widget for titles
  static Text getTitleText(String title, BuildContext context) {
    return Text(
      title,
      style: MyTextStyle(context).titleLarge,
    );
  }

  /// Navigates to a new screen
  static void pushScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  /// Formats a date to display as relative time (e.g., "2 days ago")
  static String timeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays >= 365) {
      final int years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays >= 30) {
      final int months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays >= 7) {
      final int weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    }

    return 'just now';
  }

  /// Shows a loading dialog with optional message
  static Future<void> showLoadingDialog(
    BuildContext context, {
    String? message,
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularLoadingIndicator(),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: MyTextStyle(context).bodyLarge.copyWith(
                          color: LightThemeColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Truncates text to a specified length and adds ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  /// Checks if the current theme is dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Gets the screen size
  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// Gets the screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Gets the screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Formats a date to a specified format
  static String getFormattedDate(
    DateTime date, {
    String format = 'dd MMM yyyy',
  }) {
    return DateFormat(format).format(date);
  }

  /// Removes duplicate items from a list
  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  /// Wraps a list of widgets into rows with specified number of items per row
  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];

    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }

    return wrappedList;
  }

  /// Shows a success dialog with a checkmark icon
  static void showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showIconAlertDialog(
      context,
      title: title,
      errorMessage: message,
      icon: Icons.check_circle,
      headerColor: primaryColor,
      iconColor: Colors.white,
    );
  }

  /// Shows a themed confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child:
                  Text(cancelText, style: TextStyle(color: Colors.grey[700])),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// Returns responsive padding based on screen size
  static EdgeInsets responsivePadding(BuildContext context) {
    final width = screenWidth(context);
    if (width < 600) {
      return const EdgeInsets.all(16);
    } else if (width < 1200) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(32);
    }
  }

  /// Returns a theme-appropriate color based on the current theme
  static Color getThemeAwareColor(
    BuildContext context,
    Color lightColor,
    Color darkColor,
  ) {
    return isDarkMode(context) ? darkColor : lightColor;
  }
}
