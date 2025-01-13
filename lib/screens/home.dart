import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/matches/screens/matches_screen.dart';
import 'package:tracket/notifications/screens/notifications_screen.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/screens/tournament_screen.dart';
import 'package:tracket/teams/screens/teams_screen.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';
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
    setState(() {
      _selectedIndex = 3;
    });
    try {
      final player = await FirebaseAuthMethods.getUserDetail();
      ref.read(playerProvider.notifier).setPlayer(player);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading player data: $error')),
        );
      }
    } finally {
      setState(() {
        _selectedIndex = 0;
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
    const Scaffold(body: Center(child: CircularProgressIndicator())),
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
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            iconSize: 30,
            onPressed: () {
              pushScreen(context, const NotificationsScreen());
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex % 3,
        elevation: 10,
        backgroundColor: greenColor,
        onTap: _selectItem,
        selectedItemColor: blackColor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
        showSelectedLabels: true,
        unselectedItemColor: unSelectColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.groups,
              semanticLabel: 'Teams Tab',
            ),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sports_cricket,
              semanticLabel: 'Matches Tab',
            ),
            label: 'Matches',
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
