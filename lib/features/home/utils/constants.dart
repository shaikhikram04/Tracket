import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/features/matches/screens/matches_screen.dart';
import 'package:tracket/features/teams/screens/teams_screen.dart';
import 'package:tracket/features/tournaments/tournament_screen.dart';
import 'package:tracket/utils/constants/text_strings.dart';

class HomeConstants {
  // Define screen constants
  static const int loadingScreenIndex = 3;

  // Define screens and titles as static constants
  static const List<Widget> screens = [
    TeamsScreen(),
    MatchesScreen(),
    TournamentList(),
    Scaffold(body: CircularLoadingIndicator()),
  ];

  static const List<String> titles = [
    TTextStrings.teams,
    TTextStrings.matches,
    TTextStrings.tournaments,
  ];

  // Navigation items
  static const List<BottomNavigationBarItem> navigationItems = [
    BottomNavigationBarItem(icon: Icon(Icons.groups), label: TTextStrings.teams),
    BottomNavigationBarItem(icon: Icon(Icons.sports_cricket), label: TTextStrings.matches),
    BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: TTextStrings.tournaments),
  ];
}
