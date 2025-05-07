import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class BackgroundText extends StatelessWidget {
  const BackgroundText({super.key, required this.text, this.icon, this.iconColor});

  final String text;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return Container(
      padding: TPadding.sm,
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: isDark ? 0.4 : 0.1),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          if (icon != null) Icon(icon, color: iconColor),
          Flexible(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
