import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/provider/auth_screen_size.dart';
import 'package:tracket/screens/authentication/player_auth.dart';
import 'package:tracket/screens/authentication/user_auth.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final tabBarViewHeight = ref.watch(authScreenSizeProvider);
    // Height of the status bar
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // Height of the bottom inset (e.g., navigation bar)
    final double bottomInsetHeight = MediaQuery.of(context).padding.bottom;
    final safeAreaHeight = height - statusBarHeight - bottomInsetHeight;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: safeAreaHeight),
            child: Column(
              children: [
                const SizedBox(height: 15),
                //* App logo
                Image.asset(
                  'assets/images/Tracket_logo.png',
                  height: height * 0.25,
                  fit: BoxFit.cover,
                ),
                //* Auth content
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 12,
                  ),
                  child: Card(
                    color: Theme.of(context).cardColor,
                    child: Column(
                      children: [
                        //* TabBar for show option of user & player authentication
                        TabBar(
                          dividerColor: Theme.of(context).colorScheme.secondary,
                          indicatorSize: TabBarIndicatorSize.tab,
                          controller: _tabController,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle:
                              const TextStyle(fontWeight: FontWeight.normal),
                          tabs: const [
                            Tab(
                              child: Text(
                                'User',
                                style: TextStyle(fontSize: 21),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Player',
                                style: TextStyle(fontSize: 21),
                              ),
                            ),
                          ],
                          onTap: (value) async {
                            if (_tabController.indexIsChanging) {
                              await Future.delayed(
                                  const Duration(milliseconds: 180));
                              ref
                                  .read(authScreenSizeProvider.notifier)
                                  .changeScreen(
                                    value == 0
                                        ? AuthScreenType.userLogin
                                        : AuthScreenType.playerLogin,
                                  );
                            }
                          },
                        ),

                        //* Content of TabBar for signup/login user or player
                        SizedBox(
                          height: tabBarViewHeight,
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: const [
                              UserAuth(),
                              PlayerAuth(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
