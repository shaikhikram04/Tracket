import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class BaseSelectionSheet extends StatelessWidget {
  final String title;
  final String instructions;
  final Widget content;
  final bool showCancelButton;
  final VoidCallback onCancel;
  final VoidCallback? onConfirm;
  final bool confirmEnabled;

  const BaseSelectionSheet({
    super.key,
    required this.title,
    required this.instructions,
    required this.content,
    required this.onCancel,
    this.showCancelButton = true,
    this.onConfirm,
    this.confirmEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: isDark
            ? DarkThemeColors.secondaryBackground
            : LightThemeColors.secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  instructions,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: isDark
                            ? DarkThemeColors.secondaryText
                            : LightThemeColors.secondaryText,
                      ),
                ),
              ],
            ),
          ),
          Expanded(child: content),
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              8 + MediaQuery.of(context).viewPadding.bottom,
            ),
            child: Row(
              children: [
                if (showCancelButton)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: isDark
                              ? DarkThemeColors.primaryText
                              : LightThemeColors.primaryText,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: confirmEnabled ? onConfirm : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? lightGrassGreen : grassGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: isDark
                            ? DarkThemeColors.surfaceColor
                            : LightThemeColors.surfaceColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
