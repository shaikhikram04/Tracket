import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/matches/widgets/match_card.dart';
import 'package:tracket/matches/widgets/match_tabs.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  int _selectedTabIndex = 1;

  void _onTabChange(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  MatchTabs(
                    text: 'Completed',
                    isSelected: _selectedTabIndex == 0,
                    onTap: () => _onTabChange(0),
                  ),
                  MatchTabs(
                    text: 'Live',
                    isSelected: _selectedTabIndex == 1,
                    onTap: () => _onTabChange(1),
                  ),
                  MatchTabs(
                    text: 'Upcoming',
                    isSelected: _selectedTabIndex == 2,
                    onTap: () => _onTabChange(2),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: 5,
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
