import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class BackToLoginButton extends StatelessWidget {
  const BackToLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return TextButton.icon(
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(Icons.arrow_back, color: isDark ? lightGrassGreen : grassGreen),
      label: Text(
        TTextStrings.backToLogin,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: isDark ? lightGrassGreen : grassGreen),
      ),
    );
  }
}
