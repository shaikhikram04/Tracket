import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/common/widgets/main_drawer.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/matches/screens/matches_screen.dart';
import 'package:tracket/features/notifications/screens/notifications_screen.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/features/teams/screens/teams_screen.dart';
import 'package:tracket/screens/tournament_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

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
    const Scaffold(body: CircularLoadingIndicator()),
  ];

  final List<String> _titles = [
    'Teams',
    'Matches',
    'Tournaments',
  ];

  @override
  Widget build(BuildContext context) {
    String title = _titles[_selectedIndex % 3];
    bool isTeamsScreen = _selectedIndex == 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: onPrimary,
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
              THelperFunction.pushScreen(context, const NotificationsScreen());
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
          onTap: _selectItem,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.groups),
              label: 'Teams',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_cricket),
              label: 'Matches',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Tournaments',
            ),
          ],
        ),
      ),
    );
  }
}
