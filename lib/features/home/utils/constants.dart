import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/text_strings.dart';

class HomeConstants {
  static const int loadingScreenIndex = 3;

  static const List<String> titles = [
    TTextStrings.teams,
    TTextStrings.matches,
    'Profile',
  ];

  static const List<BottomNavigationBarItem> navigationItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.groups), label: TTextStrings.teams),
    BottomNavigationBarItem(
        icon: Icon(Icons.sports_cricket), label: TTextStrings.matches),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];
}
