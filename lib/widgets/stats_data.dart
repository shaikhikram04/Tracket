import 'package:flutter/material.dart';

class StatsData extends StatelessWidget {
  const StatsData({
    super.key,
    required this.number,
    required this.label,
    this.numColor,
    this.labelColor,
    this.size = StatsDataSize.medium,
    this.showAnimation = true,
    this.alignment = Alignment.center,
    this.numberSuffix,
    this.numberPrefix,
    this.labelStyle,
    this.numberStyle,
    this.baseAnimationDuration = const Duration(milliseconds: 1500),
  });

  final int number;
  final String label;
  final Color? numColor;
  final Color? labelColor;
  final StatsDataSize size;
  final bool showAnimation;
  final Alignment alignment;
  final String? numberSuffix;
  final String? numberPrefix;
  final TextStyle? labelStyle;
  final TextStyle? numberStyle;
  final Duration baseAnimationDuration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultNumberStyle = _getNumberStyle(theme);
    final defaultLabelStyle = _getLabelStyle(theme);

    return Container(
      padding: _getPadding(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: _getCrossAlignment(),
        children: [
          if (showAnimation)
            _AnimatedNumber(
              number: number,
              style: numberStyle?.copyWith(color: numColor) ??
                  defaultNumberStyle.copyWith(
                      color: numColor ?? theme.colorScheme.primary),
              prefix: numberPrefix,
              suffix: numberSuffix,
              baseAnimationDuration: baseAnimationDuration,
            )
          else
            _StatNumber(
              number: number,
              style: numberStyle?.copyWith(color: numColor) ??
                  defaultNumberStyle.copyWith(
                      color: numColor ?? theme.colorScheme.primary),
              prefix: numberPrefix,
              suffix: numberSuffix,
            ),
          SizedBox(height: _getSpacing()),
          Text(
            label,
            style: labelStyle?.copyWith(color: labelColor) ??
                defaultLabelStyle.copyWith(
                  color: labelColor ??
                      theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case StatsDataSize.small:
        return const EdgeInsets.all(8);
      case StatsDataSize.medium:
        return const EdgeInsets.all(12);
      case StatsDataSize.large:
        return const EdgeInsets.all(16);
    }
  }

  double _getSpacing() {
    switch (size) {
      case StatsDataSize.small:
        return 4;
      case StatsDataSize.medium:
        return 8;
      case StatsDataSize.large:
        return 12;
    }
  }

  CrossAxisAlignment _getCrossAlignment() {
    switch (alignment) {
      case Alignment.centerLeft:
        return CrossAxisAlignment.start;
      case Alignment.centerRight:
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.center;
    }
  }

  TextStyle _getNumberStyle(ThemeData theme) {
    switch (size) {
      case StatsDataSize.small:
        return theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
        );
      case StatsDataSize.medium:
        return theme.textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.bold,
        );
      case StatsDataSize.large:
        return theme.textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.bold,
        );
    }
  }

  TextStyle _getLabelStyle(ThemeData theme) {
    switch (size) {
      case StatsDataSize.small:
        return theme.textTheme.bodyMedium!;
      case StatsDataSize.medium:
        return theme.textTheme.bodyLarge!;
      case StatsDataSize.large:
        return theme.textTheme.titleMedium!;
    }
  }
}

class _AnimatedNumber extends StatelessWidget {
  const _AnimatedNumber({
    required this.number,
    required this.style,
    required this.baseAnimationDuration,
    this.prefix,
    this.suffix,
  });

  final int number;
  final TextStyle style;
  final String? prefix;
  final String? suffix;
  final Duration baseAnimationDuration;

  Duration _calculateDuration() {
    // Scale duration based on number magnitude
    if (number == 0) return const Duration(milliseconds: 100);

    // Calculate the number of digits
    final digits = number.toString().length;

    // Base multiplier that increases with number size
    final multiplier = switch (digits) {
      1 => 0.3, // Small numbers (0-9)
      2 => 0.5, // Double digits (10-99)
      3 => 0.75, // Triple digits (100-999)
      4 => 1.0, // Thousands (1000-9999)
      _ => 1.25, // Large numbers (10000+)
    };

    // Calculate final duration
    final duration = baseAnimationDuration.inMilliseconds * multiplier;

    // Cap the maximum duration at 3 seconds
    return Duration(milliseconds: duration.toInt().clamp(500, 3000));
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: number.toDouble()),
      duration: _calculateDuration(),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        // Format number based on size
        String formattedNumber;
        if (value >= 1000000) {
          formattedNumber = '${(value / 1000000).toStringAsFixed(1)}M';
        } else if (value >= 1000) {
          formattedNumber = '${(value / 1000).toStringAsFixed(1)}K';
        } else {
          formattedNumber = value.toInt().toString();
        }

        return Text(
          '${prefix ?? ''}$formattedNumber${suffix ?? ''}',
          style: style,
        );
      },
    );
  }
}

class _StatNumber extends StatelessWidget {
  const _StatNumber({
    required this.number,
    required this.style,
    this.prefix,
    this.suffix,
  });

  final int number;
  final TextStyle style;
  final String? prefix;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${prefix ?? ''}$number${suffix ?? ''}',
      style: style,
    );
  }
}

enum StatsDataSize {
  small,
  medium,
  large,
}
