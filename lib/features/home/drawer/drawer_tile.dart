import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.isDark,
    required this.leadingIcon,
    this.leadingIconColor,
    required this.text,
    this.textColor,
    required this.onTap,
  });

  final bool isDark;
  final IconData leadingIcon;
  final Color? leadingIconColor;
  final String text;
  final Color? textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: primaryColor.withValues(alpha: 0.1),
      leading: Icon(
        Icons.logout,
        size: TSizes.iconMd,
        color: leadingIconColor ??
            (isDark
                ? DarkThemeColors.primaryText
                : LightThemeColors.primaryText),
      ),
      title: Text(
        TTextStrings.logout,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: textColor ??
                  (isDark
                      ? DarkThemeColors.primaryText
                      : LightThemeColors.primaryText),
            ),
      ),
      onTap: onTap,
    );
  }
}
