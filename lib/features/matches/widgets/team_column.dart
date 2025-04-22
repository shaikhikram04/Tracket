import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';

class TeamColumn extends StatelessWidget {
  const TeamColumn({
    super.key,
    required this.teamName,
    required this.teamLogo,
    this.avatarRadius = 30.0,
    this.spacing = 8.0,
    this.textStyle,
  });

  final String teamName;
  final String teamLogo;
  final double avatarRadius;
  final double spacing;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImageCircleAvatar(
          url: teamLogo,
          isTeam: true,
          radius: avatarRadius,
        ),
        SizedBox(height: spacing),
        Text(
          teamName,
          textAlign: TextAlign.center,
          style: textStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
