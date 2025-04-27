import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/list_view/list_tile_structure.dart';
import 'package:tracket/common/widgets/list_view/tile_hero_avatar.dart';
import 'package:tracket/common/widgets/list_view/tile_title_subtitle.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';

/// A customizable list tile with enhanced visual styling and interaction capabilities.
class EnhancedListTile extends StatelessWidget {
  const EnhancedListTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    required this.isPlayer,
    this.avatarRadius = TSizes.circleAvatarSm,
    this.backgroundColor,
    this.shape,
  });

  /// The URL for the avatar image
  final String imageUrl;

  /// The primary text displayed in the list tile
  final String title;

  /// The secondary text displayed below the title
  final String subtitle;

  /// Widget to display at the end of the list tile
  final Widget? trailing;

  /// Whether this represents a player (true) or team (false)
  final bool isPlayer;

  /// Callback executed when the tile is tapped
  final VoidCallback onTap;

  /// Radius of the avatar circle
  final double avatarRadius;

  /// Background color of the list tile
  final Color? backgroundColor;

  /// Custom shape for the tile
  final ShapeBorder? shape;

  /// Hero tag for the avatar
  String get _heroTag => '${isPlayer ? 'player' : 'team'}_$imageUrl';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: TPadding.paddingSm,
      decoration: _buildContainerDecoration(theme),
      child: ListTileStructure(
        backgroundColor: backgroundColor,
        onTap: onTap,
        children: [
          TileHeroAvatar(
            imageUrl: imageUrl,
            isTeam: !isPlayer,
            avatarRadius: avatarRadius,
            heroTag: _heroTag,
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
          TileTitleSubtitle(title: title, subTitle: subtitle),
          if (trailing != null) ...[
            const SizedBox(width: TSizes.spaceBtwItems),
            trailing!,
          ],
        ],
      ),
    );
  }

  /// Builds the shape for the card based on selection state
  BoxDecoration _buildContainerDecoration(ThemeData theme) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
        border: Border.all(
          color: Colors.transparent,
        ));
  }
}
