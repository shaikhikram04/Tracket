import 'package:flutter/material.dart';
import 'package:tracket/matches/widgets/match_card.dart';
import 'package:tracket/matches/widgets/match_tabs.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  int _selectedTabIndex = 1;

  void onTabChange(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              children: [
                MatchTabs(
                  text: 'Completed',
                  isSelected: _selectedTabIndex == 0,
                  onTap: () => onTabChange(0),
                ),
                MatchTabs(
                  text: 'Live',
                  isSelected: _selectedTabIndex == 1,
                  onTap: () => onTabChange(1),
                ),
                MatchTabs(
                  text: 'Upcoming',
                  isSelected: _selectedTabIndex == 2,
                  onTap: () => onTabChange(2),
                ),
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
