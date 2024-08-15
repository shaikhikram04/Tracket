import 'package:flutter/material.dart';
import 'package:tracket/widgets/matches_list.dart';
import 'package:tracket/widgets/teams_list.dart';
import 'package:tracket/widgets/tournament_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedIndex = 0;

  void _selectItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const MatchesList();

    if (_selectedIndex == 1) {
      content = const TeamsList();
    }
    if (_selectedIndex == 2) {
      content = const TournamentList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cricket Stats Manager',
        ),
      ),
      drawer: const Drawer(),
      body: content,
      floatingActionButton: IconButton(
        iconSize: 50,
        color: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.add_circle_sharp),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        elevation: 8,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        onTap: _selectItem,
        selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_cricket),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Tournament',
          ),
        ],
      ),
    );
  }
}
