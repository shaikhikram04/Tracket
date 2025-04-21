import 'package:flutter/material.dart';
import 'package:tracket/features/teams/utils/team_constants.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class CapacitySelector extends StatelessWidget {
  const CapacitySelector({
    super.key,
    required this.capacity,
    required this.onIncrement,
    required this.onDecrement,
    required this.label,
    this.minCapacity = TeamConstants.minTeamSize,
    this.maxCapacity = TeamConstants.maxTeamSize,
    this.textStyle, // Light green background
  });

  final int capacity;
  final void Function() onIncrement;
  final void Function() onDecrement;
  final String label;
  final int minCapacity;
  final int maxCapacity;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final bool canDecrement = capacity > minCapacity;
    final bool canIncrement = capacity < maxCapacity;

    final isDark = THelperFunction.isDarkMode(context);

    return Container(
      padding: TPadding.paddingXs,
      decoration: BoxDecoration(
        color: isDark
            ? DarkThemeColors.secondaryBackground
            : LightThemeColors.secondaryBackground,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label :',
            style: (textStyle ?? Theme.of(context).textTheme.titleMedium)
                ?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? primaryLight : primaryColor,
            ),
          ),
          const Spacer(),
          _CapacityButton(
            icon: Icons.remove_rounded,
            onPressed: canDecrement ? onDecrement : null,
            primaryColor: isDark ? primaryLight : primaryColor,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: TSizes.xxl4),
            padding: TPadding.hPaddingSm,
            child: Text(
              capacity.toString(),
              style: (textStyle ?? Theme.of(context).textTheme.titleMedium)
                  ?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? primaryLight : primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _CapacityButton(
            icon: Icons.add_rounded,
            onPressed: canIncrement ? onIncrement : null,
            primaryColor: isDark ? primaryLight : primaryColor,
          ),
        ],
      ),
    );
  }
}

class _CapacityButton extends StatelessWidget {
  const _CapacityButton({
    required this.icon,
    required this.onPressed,
    required this.primaryColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        child: Padding(
          padding: TPadding.xs,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: onPressed != null ? 1.0 : 0.5,
            child: Icon(
              icon,
              color: primaryColor,
              size: TSizes.iconMd,
            ),
          ),
        ),
      ),
    );
  }
}
