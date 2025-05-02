import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/home/drawer/main_drawer.dart';
import 'package:tracket/features/matches/screens/matches_screen.dart';
import 'package:tracket/features/notifications/screens/notifications_screen.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/features/teams/screens/teams_screen.dart';
import 'package:tracket/features/tournaments/tournament_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
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
          SnackBar(
              content: Text('${TTextStrings.loadingPlayerDataError} $error')),
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
    TTextStrings.teams,
    TTextStrings.matches,
    TTextStrings.tournaments,
  ];

  @override
  Widget build(BuildContext context) {
    String title = _titles[_selectedIndex % 3];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: onPrimary,
        title: Text(
          title,
          style: const TextStyle(
            color: onPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                color: onPrimary,
                iconSize: TSizes.iconAppBar,
                onPressed: () {
                  THelperFunction.pushScreen(
                      context, const NotificationsScreen());
                },
              ),
              // const Positioned(
              //   top: 10,
              //   right: 10,
              //   child: CircleAvatar(
              //     backgroundColor: Colors.redAccent,
              //     radius: 5,
              //   ),
              // ),
            ],
          ),
          const SizedBox(width: TSizes.sm),
        ],
      ),
      drawer: const MainDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: TSizes.blurRadiusMd,
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
              label: TTextStrings.teams,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_cricket),
              label: TTextStrings.matches,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: TTextStrings.tournaments,
            ),
          ],
        ),
      ),
    );
  }
}
