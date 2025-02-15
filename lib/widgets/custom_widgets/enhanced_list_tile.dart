import 'package:flutter/material.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';

class EnhancedListTile extends StatelessWidget {
  const EnhancedListTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    required this.isPlayer,
    this.avatarRadius = 30,
    this.contentPadding,
    this.titleMaxLines = 1,
    this.subtitleMaxLines = 2,
    this.isSelected = false,
    this.backgroundColor,
    this.highlightColor,
    this.rippleColor,
    this.shape,
  });

  final String imageUrl;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool isPlayer;
  final VoidCallback? onTap;
  final double avatarRadius;
  final EdgeInsetsGeometry? contentPadding;
  final int titleMaxLines;
  final int subtitleMaxLines;
  final bool isSelected;
  final Color? backgroundColor;
  final Color? highlightColor;
  final Color? rippleColor;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = MyTextStyle(context);
    return Card(
      elevation: isSelected ? 2 : 0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.5)
                  : Colors.transparent,
            ),
          ),
      child: Material(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          highlightColor:
              highlightColor ?? theme.highlightColor.withValues(alpha: 0.1),
          splashColor: rippleColor ?? theme.splashColor.withValues(alpha: 0.1),
          child: Padding(
            padding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: '${isPlayer ? 'player' : 'team'}_$imageUrl',
                  child: _buildAvatar(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: textStyle.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: titleMaxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textStyle.bodyMedium.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.7),
                        ),
                        maxLines: subtitleMaxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
        ],
      ),
      child: getCircleAvatar(
        url: imageUrl,
        isTeam: !isPlayer,
        radius: avatarRadius,
      ),
    );
  }
}
