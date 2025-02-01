import 'package:flutter/material.dart';
import 'package:tracket/matches/widgets/match_card.dart';
import 'package:tracket/matches/widgets/match_tabs.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              children: [
                MatchTabs(text: 'Completed', isSelected: true),
                MatchTabs(text: 'Live', isSelected: false),
                MatchTabs(text: 'Upcoming', isSelected: false),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return const MatchCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
