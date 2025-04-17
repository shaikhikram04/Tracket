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
