import 'package:flutter/material.dart';
import 'package:tracket/matches/widgets/match_card.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return const MatchCard();
        },
      ),
    );
  }
}
