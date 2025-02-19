import 'package:flutter/material.dart';

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
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 2);
      case HighlightSize.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
      case HighlightSize.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 6);
    }
  }

  BorderRadius get _defaultBorderRadius {
    switch (size) {
      case HighlightSize.small:
        return BorderRadius.circular(12);
      case HighlightSize.medium:
        return BorderRadius.circular(15);
      case HighlightSize.large:
        return BorderRadius.circular(18);
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
          ? 12
          : size == HighlightSize.medium
              ? 14
              : 16,
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
