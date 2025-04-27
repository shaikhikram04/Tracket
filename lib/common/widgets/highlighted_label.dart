import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';

enum HighlightSize {
  small, // Compact size
  medium, // Default size
  large // Larger size
}

class HighlightedLabel extends StatelessWidget {
  const HighlightedLabel({
    super.key,
    required this.text,
    this.size = HighlightSize.medium,
    required this.color,
    this.secondaryColor,
    this.textStyle,
    this.margin,
    this.padding,
    this.borderRadius,
  });

  final String text;
  final TextStyle? textStyle;
  final Color color;
  final Color? secondaryColor;
  final HighlightSize size;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  EdgeInsetsGeometry get _defaultMargin {
    switch (size) {
      case HighlightSize.small:
        return const EdgeInsets.only(right: 4, bottom: 4);
      case HighlightSize.medium:
        return const EdgeInsets.only(right: 5, bottom: 5);
      case HighlightSize.large:
        return const EdgeInsets.only(right: 6, bottom: 6);
    }
  }

  EdgeInsetsGeometry get _defaultPadding {
    switch (size) {
      case HighlightSize.small:
        return TPadding.highlightedLabelSm;
      case HighlightSize.medium:
        return TPadding.highlightedLabelMd;
      case HighlightSize.large:
        return TPadding.highlightedLabelLg;
    }
  }

  BorderRadius get _defaultBorderRadius {
    switch (size) {
      case HighlightSize.small:
        return BorderRadius.circular(TSizes.borderRadiusLg);
      case HighlightSize.medium:
        return BorderRadius.circular(TSizes.borderRadiusXl);
      case HighlightSize.large:
        return BorderRadius.circular(TSizes.borderRadiusXxl);
    }
  }

  BoxDecoration _getDecoration() {
    return BoxDecoration(
      color: secondaryColor ?? color.withValues(alpha: 0.1),
      borderRadius: borderRadius ?? _defaultBorderRadius,
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    final defaultStyle = TextStyle(
      color: color,
      fontSize: size == HighlightSize.small
          ? TSizes.fontSizeXs
          : size == HighlightSize.medium
              ? TSizes.fontSizeSm
              : TSizes.fontSizeMd,
      fontWeight: FontWeight.w500,
    );

    return textStyle?.copyWith(
          color: textStyle?.color ?? color,
        ) ??
        defaultStyle;
  }

  @override
  Widget build(BuildContext context) {
    Widget labelContent = Text(text, style: _getTextStyle(context));

    Widget container = Material(
      color: Colors.transparent,
      borderRadius: borderRadius ?? _defaultBorderRadius,
      child: Container(
        margin: margin ?? _defaultMargin,
        padding: padding ?? _defaultPadding,
        decoration: _getDecoration(),
        child: labelContent,
      ),
    );
    return container;
  }
}
