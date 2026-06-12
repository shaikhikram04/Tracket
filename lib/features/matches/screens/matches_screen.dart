import 'package:flutter/material.dart';
import 'package:tracket/features/matches/widgets/match_tabs.dart';
import 'package:tracket/features/matches/widgets/matches_fetcher.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/enums.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key, this.onGoToTeams});

  final VoidCallback? onGoToTeams;

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
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: CricketMatchTabs(
              tabs: const [
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
      floatingActionButton: widget.onGoToTeams != null
          ? FloatingActionButton.extended(
              onPressed: widget.onGoToTeams,
              backgroundColor: primaryColor,
              foregroundColor: onPrimary,
              icon: const Icon(Icons.sports_cricket_rounded),
              label: const Text(
                'Challenge a Team',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          : null,
    );
  }
}
