import 'package:flutter/material.dart';
import 'package:tracket/utils/utils.dart';

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
      spacing: spacing,
      children: [
        getCircleAvatar(
          url: teamLogo,
          isTeam: true,
          radius: avatarRadius,
        ),
        Text(
          teamName,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
      ],
    );
  }
}
