import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/authentication/screens/player_auth.dart';
import 'package:tracket/authentication/providers/auth_screen_size.dart';
import 'package:tracket/authentication/screens/user_auth.dart';
import 'package:tracket/utils/utils.dart';

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
    final safeAreaHeight = getSafeAreaHeight(context);

    return Scaffold(
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
                  height: height * 0.25 > 200
                      ? 200
                      : height * 0.25, //? Maximum height of 200
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 100),
                ),
                //* Auth content
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                  ),
                  child: Card(
                    color: Theme.of(context).cardColor,
                    elevation: 5,
                    shadowColor: Colors.grey.shade800,
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
                                'Player',
                                style: TextStyle(fontSize: 21),
                                semanticsLabel: 'Player Authentication',
                              ),
                            ),
                            Tab(
                              child: Text(
                                'User',
                                style: TextStyle(fontSize: 21),
                                semanticsLabel: 'User Authentication',
                              ),
                            ),
                          ],
                          onTap: (value) async {
                            try {
                              if (_tabController.indexIsChanging) {
                                await Future.delayed(
                                    const Duration(milliseconds: 180));
                                ref
                                    .read(authScreenSizeProvider.notifier)
                                    .changeSizeByIndex(value);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                showSnackBar(
                                    'Error switching tabs: $e', context);
                              }
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
                              PlayerAuth(),
                              UserAuth(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
