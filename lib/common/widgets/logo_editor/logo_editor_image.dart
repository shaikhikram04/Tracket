import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class LogoEditorImage extends StatelessWidget {
  const LogoEditorImage({
    super.key,
    required this.logoUrl,
    required this.image,
  });

  final String logoUrl;
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? lightGrassGreen : grassGreen,
          width: 2,
        ),
        boxShadow:  const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: TSizes.blurRadiusMd,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ImageCircleAvatar(
        url: logoUrl,
        isTeam: true,
        radius: TSizes.circleAvatarLg,
        image: image,
      ),
    );
  }
}
