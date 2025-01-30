import 'package:flutter/material.dart';
import 'package:tracket/utils/utils.dart';

class TeamColumn extends StatelessWidget {
  const TeamColumn({
    super.key,
    required this.teamName,
    required this.teamLogo,
    this.avatarRadius = 30.0,
    this.spacing = 8.0,
  });

  final String teamName;
  final String teamLogo;
  final double avatarRadius;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
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
          ),
        ],
      ),
    );
  }
}
