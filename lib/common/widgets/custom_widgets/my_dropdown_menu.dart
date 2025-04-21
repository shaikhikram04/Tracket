import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/devices/devices_utility.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class MyDropdownMenu extends StatelessWidget {
  const MyDropdownMenu({
    super.key,
    required this.options,
    required this.onSelect,
    this.initialSelection,
    this.controller,
    this.hintText,
    this.label = '',
    this.leadingIcon,
    this.width,
    this.enabled = true,
    this.menuMaxHeight,
    this.enableFilter = false,
    this.errorText,
    this.requestFocusOnTap = false,
  });

  final List<String> options;
  final String label;
  final void Function(String? value) onSelect;
  final String? initialSelection;
  final TextEditingController? controller;
  final String? hintText;
  final Icon? leadingIcon;
  final double? width;
  final bool enabled;

  final double? menuMaxHeight;
  final bool enableFilter;
  final String? errorText;
  final bool requestFocusOnTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    final defaultWidth = width ?? screenWidth * 0.8;

    final isDark = THelperFunction.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownMenu<String>(
          enabled: enabled,
          initialSelection: initialSelection,
          controller: controller,
          onSelected: onSelect,
          width: defaultWidth,
          enableFilter: enableFilter,
          enableSearch: enableFilter,
          requestFocusOnTap: requestFocusOnTap,
          menuHeight: menuMaxHeight,
          label: label.isEmpty
              ? null
              : Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? DarkThemeColors.primaryText
                        : LightThemeColors.primaryText,
                  ),
                ),
          leadingIcon: leadingIcon != null
              ? Icon(
                  leadingIcon!.icon,
                  color: isDark ? DarkThemeColors.primaryText : LightThemeColors.primaryText,
                  size: TSizes.iconXsSm,
                )
              : null,
          trailingIcon: Icon(
            Icons.arrow_drop_down,
            color: enabled
                ? isDark
                    ? DarkThemeColors.primaryText
                    : LightThemeColors.primaryText
                : isDark
                    ? DarkThemeColors.tertiaryText
                    : LightThemeColors.tertiaryText,
          ),
          hintText: hintText,
          errorText: errorText,
          dropdownMenuEntries: options
              .map((option) => DropdownMenuEntry<String>(
                    value: option,
                    label: option.toUpperCase(),
                    style: MenuItemButton.styleFrom(
                      foregroundColor: isDark
                          ? DarkThemeColors.primaryText
                          : LightThemeColors.primaryText,
                      backgroundColor: isDark
                          ? DarkThemeColors.secondaryBackground
                          : LightThemeColors.secondaryBackground,
                      padding: TPadding.paddingMd,
                    ),
                  ))
              .toList(),
        ),
        if (errorText != null) ...[
          const SizedBox(height: TSizes.xs),
          Padding(
            padding: const EdgeInsets.only(left: TSizes.spaceBtwItems),
            child: Text(
              errorText!,
              style: theme.textTheme.bodySmall!.copyWith(
                color: InteractiveColors.inputError,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
