import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';

class EnhancedListTile extends StatelessWidget {
  const EnhancedListTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    required this.isPlayer,
    this.onLongPress,
    this.avatarRadius = TSizes.circleAvatarSm,
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
  final VoidCallback? onLongPress;
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

    return Card(
      elevation: isSelected ? TSizes.cardElevation : 0,
      margin: TPadding.paddingSm,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
            side: BorderSide(
              color: isSelected
                  ? theme.primaryColor.withValues(alpha: 0.5)
                  : Colors.transparent,
            ),
          ),
      child: Material(
        color: backgroundColor ?? primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          highlightColor:
              highlightColor ?? theme.highlightColor.withValues(alpha: 0.1),
          splashColor: rippleColor ?? theme.splashColor.withValues(alpha: 0.1),
          child: Padding(
            padding: contentPadding ?? TPadding.paddingMd,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: '${isPlayer ? 'player' : 'team'}_$imageUrl',
                  child: _buildAvatar(),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: titleMaxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: TSizes.xs),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium!.copyWith(
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
                  const SizedBox(width: TSizes.spaceBtwItems),
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
      child: ImageCircleAvatar(
        url: imageUrl,
        isTeam: !isPlayer,
        radius: avatarRadius,
      ),
    );
  }
}
