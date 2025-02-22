import 'package:flutter/material.dart';
import 'package:tracket/matches/widgets/match_tabs.dart';
import 'package:tracket/matches/widgets/matches_fetcher.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  int _selectedTabIndex = 0;

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
              child: CricketMatchTabs(
                tabs: [
                  MatchTabData(
                    label: 'My Matches',
                    count: 0,
                    isLive: false,
                  ),
                  MatchTabData(
                    label: 'Completed',
                    count: 0,
                    isLive: false,
                  ),
                  MatchTabData(
                    label: 'Live',
                    count: 0,
                    isLive: true,
                  ),
                  MatchTabData(
                    label: 'Upcoming',
                    count: 0,
                    isLive: false,
                  ),
                ],
                selectedIndex: _selectedTabIndex,
                onTabSelected: _onTabChange,
              ),
            ),
            Expanded(
              child: MatchesFetcher(
                type: MatchesFetcherType.values[_selectedTabIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
