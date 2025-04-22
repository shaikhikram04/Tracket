import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton._({
    required this.onPressed,
    required this.child,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.elevation,
    this.width,
    this.height,
    this.borderRadius,
    this.icon,
    this.iconPosition = IconPosition.start,
    this.isPrimary = true,
  });

  // Factory constructors for different button variants
  static Widget primary({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Color? backgroundColor,
    Color? foregroundColor,
    ButtonSize size = ButtonSize.medium,
    double? width,
    double? height,
    double? borderRadius,
    double? elevation,
    Widget? icon,
    IconPosition iconPosition = IconPosition.start,
    TextStyle? textStyle,
  }) {
    return CustomButton._(
      onPressed: isLoading ? null : onPressed,
      variant: ButtonVariant.primary,
      isLoading: isLoading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      size: size,
      width: width,
      height: height,
      borderRadius: borderRadius,
      elevation: elevation,
      icon: icon,
      iconPosition: iconPosition,
      child: Text(text, style: textStyle),
    );
  }

  static Widget secondary({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    ButtonSize size = ButtonSize.medium,
    double? width,
    double? height,
    double? borderRadius,
    double? elevation,
    Widget? icon,
    IconPosition iconPosition = IconPosition.start,
    TextStyle? textStyle,
  }) {
    return CustomButton._(
      onPressed: isLoading ? null : onPressed,
      variant: ButtonVariant.secondary,
      isLoading: isLoading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      size: size,
      width: width,
      height: height,
      borderRadius: borderRadius,
      elevation: elevation,
      icon: icon,
      iconPosition: iconPosition,
      isPrimary: false,
      child: Text(text, textAlign: TextAlign.center, style: textStyle),
    );
  }

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? elevation;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Widget? icon;
  final IconPosition iconPosition;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getColors(theme);
    final sizes = _getSizes();

    return SizedBox(
      width: width,
      height: height,
      child: isPrimary
          ? ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                elevation: onPressed == null ? 0 : null,
                padding: sizes.padding,
                minimumSize: Size(sizes.minWidth, sizes.minHeight),
              ),
              child: _ButtonChild(
                isLoading: isLoading,
                icon: icon,
                iconPosition: iconPosition,
                foregroundColor: colors.foreground,
                child: child,
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                elevation: onPressed == null ? 0 : null,
                padding: sizes.padding,
                minimumSize: Size(sizes.minWidth, sizes.minHeight),
                side: BorderSide(
                  color: borderColor ?? Colors.black,
                  width: 1.5,
                ),
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
              ),
              child: _ButtonChild(
                isLoading: isLoading,
                icon: icon,
                iconPosition: iconPosition,
                foregroundColor: foregroundColor ?? Colors.black,
                child: child,
              ),
            ),
    );
  }

  ButtonColors _getColors(ThemeData theme) {
    final defaultPrimary = theme.colorScheme.primary;
    final defaultOnPrimary = theme.colorScheme.onPrimary;

    switch (variant) {
      case ButtonVariant.primary:
        return ButtonColors(
          background: backgroundColor ?? defaultPrimary,
          foreground: foregroundColor ?? defaultOnPrimary,
          disabledBackground: theme.disabledColor,
          disabledForeground:
              theme.colorScheme.onSurface.withValues(alpha: 0.38),
          border: Colors.transparent,
        );
      case ButtonVariant.secondary:
        return ButtonColors(
          background: backgroundColor ?? theme.colorScheme.surface,
          foreground: foregroundColor ?? defaultPrimary,
          disabledBackground: theme.colorScheme.surface,
          disabledForeground: theme.disabledColor,
          border: borderColor ?? defaultPrimary,
        );
    }
  }

  ButtonSizes _getSizes() {
    switch (size) {
      case ButtonSize.small:
        return const ButtonSizes(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minWidth: 64,
          minHeight: 32,
          borderRadius: 16,
        );
      case ButtonSize.medium:
        return const ButtonSizes(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minWidth: 80,
          minHeight: 40,
          borderRadius: 20,
        );
      case ButtonSize.large:
        return const ButtonSizes(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          minWidth: 96,
          minHeight: 48,
          borderRadius: 24,
        );
    }
  }
}

class _ButtonChild extends StatelessWidget {
  const _ButtonChild({
    required this.child,
    required this.isLoading,
    required this.foregroundColor,
    this.icon,
    this.iconPosition = IconPosition.start,
  });

  final Widget child;
  final bool isLoading;
  final Color foregroundColor;
  final Widget? icon;
  final IconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    }

    if (icon == null) return child;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (iconPosition == IconPosition.start) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        child,
        if (iconPosition == IconPosition.end) ...[
          const SizedBox(width: 8),
          icon!,
        ],
      ],
    );
  }
}

enum ButtonVariant {
  primary,
  secondary,
}

enum ButtonSize {
  small,
  medium,
  large,
}

enum IconPosition {
  start,
  end,
}

class ButtonColors {
  const ButtonColors({
    required this.background,
    required this.foreground,
    required this.disabledBackground,
    required this.disabledForeground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color disabledBackground;
  final Color disabledForeground;
  final Color border;
}

class ButtonSizes {
  const ButtonSizes({
    required this.padding,
    required this.minWidth,
    required this.minHeight,
    required this.borderRadius,
  });

  final EdgeInsetsGeometry padding;
  final double minWidth;
  final double minHeight;
  final double borderRadius;
}
