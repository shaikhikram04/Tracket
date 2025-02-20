import 'package:flutter/material.dart';
import 'package:tracket/notifications/widgets/manage_challenges_screen.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key, this.teamId});

  final String? teamId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges'),
      ),
      body: ManageChallengesScreen(teamId: teamId),
    );
  }
}