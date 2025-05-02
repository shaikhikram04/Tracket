import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/stats_widget/stat_label.dart';
import 'package:tracket/common/widgets/stats_widget/stat_number.dart';

class StatsData extends StatelessWidget {
  const StatsData({
    super.key,
    required this.number,
    required this.label,
    this.numColor,
    this.labelColor,
    this.size = StatsDataSize.medium,
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
        spacing: _getSpacing(),
        children: [
          StatNumber(
            number: number,
            style: numberStyle?.copyWith(color: numColor) ??
                defaultNumberStyle.copyWith(
                    color: numColor ?? theme.colorScheme.primary),
            prefix: numberPrefix,
            suffix: numberSuffix,
          ),
          StatLabel(
            label: label,
            labelStyle: labelStyle,
            labelColor: labelColor,
            defaultLabelStyle: defaultLabelStyle,
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

enum StatsDataSize {
  small,
  medium,
  large,
}
