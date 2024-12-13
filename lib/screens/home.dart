import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tracket/screens/create_team_screen.dart';
import 'package:tracket/screens/matches_screen.dart';
import 'package:tracket/screens/teams_screen.dart';
import 'package:tracket/screens/tournament_screen.dart';
import 'package:tracket/widgets/main_drawer.dart';

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

  void _onCreate() {
    if (_selectedIndex == 1) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const CreateTeamScreen(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const MatchesList();
    String title = 'Matches';

    if (_selectedIndex == 1) {
      content = const TeamsList();
      title = 'Team';
    }
    if (_selectedIndex == 2) {
      content = const TournamentList();
      title = 'Tornament';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      drawer: const MainDrawer(),
      body: content,
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
            label: 'Tournaments',
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.group_add),
            label: 'Join Team',
            onTap: () {
              // Navigate to Join Team Screen
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.create),
            label: 'Create Team',
            onTap: () {
              // Navigate to Create Team Screen
            },
          ),
        ],
      ),
    );
  }
}
