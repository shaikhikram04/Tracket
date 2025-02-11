import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/matches/screens/matches_screen.dart';
import 'package:tracket/notifications/screens/notifications_screen.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/screens/tournament_screen.dart';
import 'package:tracket/teams/screens/teams_screen.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/main_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _selectedIndex = 1;
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
    setState(() {
      _selectedIndex = 3;
    });
    try {
      final player = await FirebaseAuthMethods().getUserDetail;
      ref.read(playerProvider.notifier).setPlayer(player);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading player data: $error')),
        );
      }
    } finally {
      setState(() {
        _selectedIndex = 1;
      });
    }
  }

  void _selectItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    const TeamsScreen(),
    const MatchesScreen(),
    const TournamentList(),
    Scaffold(body: getCircleLoadingIndicator()),
  ];

  final List<String> _titles = [
    'Team',
    'Matches',
    'Tournament',
  ];

  @override
  Widget build(BuildContext context) {
    String title = _titles[_selectedIndex % 3];
    bool isTeamsScreen = _selectedIndex == 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2ecc71),
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              pushScreen(context, NotificationsScreen());
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: isTeamsScreen ? const MainDrawer() : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex % 3,
          type: BottomNavigationBarType.shifting,
          backgroundColor: Colors.white,
          elevation: 10,
          onTap: _selectItem,
          selectedItemColor: const Color(0xFF2ecc71),
          unselectedItemColor: Colors.grey.shade500,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF2ecc71),
          ),
          showSelectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.groups),
              label: 'Teams',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_cricket),
              label: 'Matches',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Tournaments',
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
