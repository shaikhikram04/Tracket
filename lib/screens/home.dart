import 'package:flutter/material.dart';
import 'package:tracket/resources/firebase_auth_methods.dart';
import 'package:tracket/screens/authentication/auth_screen.dart';
import 'package:tracket/screens/matches_screen.dart';
import 'package:tracket/screens/teams_screen.dart';
import 'package:tracket/screens/tournament_screen.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';

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

  Future<void> _logoutUser() async {
    final result = await FirebaseAuthMethods.logoutUser();
    if (!mounted) return;
    if (result != 'success') {
      showSnackBar(result, context);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const MatchesList();
    final width = MediaQuery.of(context).size.width;

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
      drawer: Drawer(
        backgroundColor: lightBackgroundColor,
        width: width * 0.7,
        child: Column(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    lightDrawerBgColor,
                    lightDrawerBgColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/Default_user_pfp.jpg',
                    ),
                    radius: 40,
                  ),
                  const SizedBox(width: 18),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: onLightDrawer),
                      ),
                      Text(
                        'Role',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: onLightDrawer),
                      )
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              tileColor: const Color.fromARGB(255, 221, 237, 221),
              leading: const Icon(
                Icons.logout,
                size: 26,
                color: Colors.red,
              ),
              title: Text(
                'Logout',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.red),
              ),
              onTap: _logoutUser,
            ),
          ],
        ),
      ),
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
            label: 'Tournaments',
          ),
        ],
      ),
    );
  }
}
