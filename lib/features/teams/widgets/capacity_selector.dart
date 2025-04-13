import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';

class CapacitySelector extends StatelessWidget {
  const CapacitySelector({
    super.key,
    required this.capacity,
    required this.onIncrement,
    required this.onDecrement,
    required this.label,
    this.labelColor,
    this.minCapacity = 0,
    this.maxCapacity = 30,
    this.primaryColor = grassGreen, // Dark green default
    this.backgroundColor = LightThemeColors.surfaceColor,
    this.textStyle, // Light green background
  });

  final int capacity;
  final void Function() onIncrement;
  final void Function() onDecrement;
  final String label;
  final Color? labelColor;
  final int minCapacity;
  final int maxCapacity;
  final Color primaryColor;
  final Color backgroundColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final bool canDecrement = capacity > minCapacity;
    final bool canIncrement = capacity < maxCapacity;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label:',
            style: (textStyle ?? Theme.of(context).textTheme.titleMedium)
                ?.copyWith(
              fontWeight: FontWeight.w600,
              color: labelColor ?? primaryColor,
            ),
          ),
          const Spacer(),
          _CapacityButton(
            icon: Icons.remove_rounded,
            onPressed: canDecrement ? onDecrement : null,
            primaryColor: primaryColor,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 48),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              capacity.toString(),
              style: (textStyle ?? Theme.of(context).textTheme.titleMedium)
                  ?.copyWith(
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _CapacityButton(
            icon: Icons.add_rounded,
            onPressed: canIncrement ? onIncrement : null,
            primaryColor: primaryColor,
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
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: onPressed != null ? 1.0 : 0.5,
            child: Icon(
              icon,
              color: primaryColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
