import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/image_strings.dart';

class ImageCircleAvatar extends StatelessWidget {
  const ImageCircleAvatar({
    super.key,
    required this.url,
    required this.isTeam,
    required this.radius,
    this.image,
    this.hasBorder = true,
  });

  final String url;
  final Uint8List? image;
  final bool isTeam;
  final double radius;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    AssetImage defaultImage =
        AssetImage(isTeam ? TImages.teamDefaultLogo : TImages.playerDefaultPfp);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: hasBorder
            ? Border.all(
                color: LightThemeColors.primaryText, // Border color
                width: 2.0, // Border width
              )
            : null,
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.green.shade200,
        backgroundImage: image != null
            ? MemoryImage(image!)
            : url.isEmpty
                ? defaultImage
                : NetworkImage(url),
        onBackgroundImageError: (_, __) => defaultImage,
      ),
    );
  }
}
