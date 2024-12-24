import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/provider/player_provider.dart';
import 'package:tracket/resources/firebase_auth_methods.dart';
import 'package:tracket/screens/matches_screen.dart';
import 'package:tracket/screens/teams/teams_screen.dart';
import 'package:tracket/screens/tournament_screen.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/widgets/main_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await loadPlayerData();
      },
    );
  }

  Future<void> loadPlayerData() async {
    final player = await FirebaseAuthMethods.getUserDetail();
    ref.read(playerProvider.notifier).setPlayer(player);
    print(player);
  }

  void _selectItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const MatchesScreen();
    String title = 'Matches';

    if (_selectedIndex == 1) {
      content = const TeamsScreen();
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
        backgroundColor: greenColor,
        onTap: _selectItem,
        selectedItemColor: blackColor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
        showSelectedLabels: true,
        unselectedItemColor: unSelectColor,
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
    );
  }
}
