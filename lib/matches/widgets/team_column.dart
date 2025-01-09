import 'package:flutter/material.dart';
import 'package:tracket/utils/utils.dart';

class TeamColumn extends StatelessWidget {
  const TeamColumn({super.key, required this.teamName, required this.teamLogo});

  final String teamName;
  final String teamLogo;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        getCircleAvatar(url: teamLogo, isTeam: true, radius: 30),
        Text(teamName),
      ],
    );
  }
}
