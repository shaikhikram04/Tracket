import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';

class TileHeroAvatar extends StatelessWidget {
  const TileHeroAvatar({
    super.key,
    required this.imageUrl,
    required this.isTeam,
    required this.avatarRadius,
    required this.heroTag,
  });

  final String imageUrl;
  final bool isTeam;
  final double avatarRadius;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ImageCircleAvatar(
          url: imageUrl,
          isTeam: isTeam,
          radius: avatarRadius,
        ),
      ),
    );
  }
}
