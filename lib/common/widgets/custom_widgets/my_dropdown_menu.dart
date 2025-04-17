import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/devices/devices_utility.dart';

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
    this.textStyle,
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
  final TextStyle? textStyle;
  final double? menuMaxHeight;
  final bool enableFilter;
  final String? errorText;
  final bool requestFocusOnTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    final defaultWidth = width ?? screenWidth * 0.8;

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
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
          leadingIcon: leadingIcon != null
              ? Icon(
                  leadingIcon!.icon,
                  color: theme.colorScheme.primary,
                  size: TSizes.iconMd,
                )
              : null,
          trailingIcon: Icon(
            Icons.arrow_drop_down,
            color: enabled
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.38),
          ),
          hintText: hintText,
          errorText: errorText,
          // textStyle: textStyle ?? theme.textTheme.bodyLarge,
          // menuStyle: MenuStyle(
          //   backgroundColor: WidgetStatePropertyAll(
          //     theme.colorScheme.surface,
          //   ),
          //   elevation: const WidgetStatePropertyAll(4),
          //   shadowColor: WidgetStatePropertyAll(
          //     Colors.black.withValues(alpha: 0.1),
          //   ),
          //   surfaceTintColor: WidgetStatePropertyAll(
          //     theme.colorScheme.surfaceTint,
          //   ),
          //   padding: const WidgetStatePropertyAll(
          //     TPadding.vPaddingSm,
          //   ),
          // ),
          // inputDecorationTheme: InputDecorationTheme(
          //   filled: true,
          //   fillColor: enabled
          //       ? theme.colorScheme.surface
          //       : theme.colorScheme.onSurface.withValues(alpha: 0.04),
          //   border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          //     borderSide: BorderSide(
          //       color: theme.colorScheme.outline,
          //     ),
          //   ),
          //   enabledBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          //     borderSide: BorderSide(
          //       color: theme.colorScheme.outline.withValues(alpha: 0.5),
          //     ),
          //   ),
          //   focusedBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          //     borderSide: BorderSide(
          //       color: theme.colorScheme.primary,
          //       width: 2,
          //     ),
          //   ),
          //   errorBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          //     borderSide: BorderSide(
          //       color: theme.colorScheme.error,
          //     ),
          //   ),
          //   contentPadding: TPadding.paddingMd,
          // ),
          dropdownMenuEntries: options
              .map((option) => DropdownMenuEntry<String>(
                    value: option,
                    label: option.toUpperCase(),
                    style: MenuItemButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                      backgroundColor: Colors.transparent,
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
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
