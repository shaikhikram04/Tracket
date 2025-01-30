import 'package:flutter/material.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/utils/utils.dart';

class PlayerColumn extends StatelessWidget {
  const PlayerColumn({
    super.key,
    required this.profileImageUrl,
    required this.playerName,
    required this.cricketRole,
  });

  final String profileImageUrl;
  final String playerName;
  final CricketRole cricketRole;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getCircleAvatar(
          url: profileImageUrl,
          isTeam: false,
          radius: 35,
        ),
        const SizedBox(height: 2),
        Text(playerName),
        Text(cricketRole.name),
      ],
    );
  }
}
