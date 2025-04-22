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
                      theme.textTheme.titleSmall?.color?.withValues(alpha: 0.7),
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
        return const EdgeInsets.all(4);
      case StatsDataSize.medium:
        return const EdgeInsets.all(8);
      case StatsDataSize.large:
        return const EdgeInsets.all(12);
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
    this.prefix,
    this.suffix,
  });

  final int number;
  final TextStyle style;
  final String? prefix;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    // Format number based on size
    String formattedNumber;
    if (number >= 1000000) {
      formattedNumber = '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      formattedNumber = '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      formattedNumber = number.toInt().toString();
    }

    return Text(
      '${prefix ?? ''}$formattedNumber${suffix ?? ''}',
      style: style,
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
