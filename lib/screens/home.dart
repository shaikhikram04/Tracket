import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/resources/firebase_auth_methods.dart';
import 'package:tracket/screens/matches_screen.dart';
import 'package:tracket/screens/tournament_screen.dart';
import 'package:tracket/teams/screens/teams_screen.dart';
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
    try {
      final player = await FirebaseAuthMethods.getUserDetail();
      ref.read(playerProvider.notifier).setPlayer(player);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading player data: $error')),
        );
      }
    }
  }

  void _selectItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    const MatchesScreen(),
    const TeamsScreen(),
    const TournamentList(),
  ];

  final List<String> _titles = [
    'Matches',
    'Team',
    'Tournament',
  ];

  @override
  Widget build(BuildContext context) {
    String title = _titles[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      drawer: const MainDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
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
            icon: Icon(
              Icons.sports_cricket,
              semanticLabel: 'Matches Tab',
            ),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.groups,
              semanticLabel: 'Teams Tab',
            ),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bar_chart,
              semanticLabel: 'Tournaments Tab',
            ),
            label: 'Tournaments',
          ),
        ],
      ),
    );
  }
}
