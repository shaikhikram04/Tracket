import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/features/players/models/player_cricket_detail.dart';

class PlayerColumn extends StatelessWidget {
  const PlayerColumn({
    super.key,
    required this.profileImageUrl,
    required this.playerName,
    required this.cricketRole,
    this.avatarRadius = 35.0,
    this.spacing = 2.0,
  });

  final String profileImageUrl;
  final String playerName;
  final CricketRole cricketRole;
  final double avatarRadius;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageCircleAvatar(
          url: profileImageUrl,
          isTeam: false,
          radius: avatarRadius,
        ),
        SizedBox(height: spacing),
        Text(playerName),
        Text(cricketRole.name),
      ],
    );
  }
}
