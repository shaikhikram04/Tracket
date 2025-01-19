import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/authentication/providers/auth_screen_size.dart';
import 'package:tracket/authentication/widgets/player_auth.dart';
import 'package:tracket/authentication/widgets/user_auth.dart';
import 'package:tracket/utils/utils.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const double _maxLogoHeight = 200.0;
  static const double _tabFontSize = 21.0;
  static const int _tabSwitchDelay = 180;
  static const double _verticalSpacing = 15.0;
  static const double _bottomPadding = 40.0;
  static const EdgeInsets _horizontalPadding =
      EdgeInsets.symmetric(horizontal: 17);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _handleTabChange(int index) async {
    try {
      if (_tabController.indexIsChanging) {
        await Future.delayed(const Duration(milliseconds: _tabSwitchDelay));
        ref.read(authScreenSizeProvider.notifier).changeSizeByIndex(index);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar('Error switching tabs: $e', context);
      }
    }
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
                const SizedBox(height: _verticalSpacing),
                //* App logo
                _buildAppLogo(height),
                //* Auth content
                Padding(
                  padding: _horizontalPadding,
                  child: Card(
                    color: Theme.of(context).cardColor,
                    elevation: 5,
                    shadowColor: Colors.grey.shade800,
                    child: Column(
                      children: [
                        //* TabBar for show option of user & player authentication
                        _buildAuthTabs(),
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
                const SizedBox(height: _bottomPadding)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo(double height) {
    return Image.asset(
      'assets/images/Tracket_logo.png',
      height: height * 0.25 > _maxLogoHeight ? _maxLogoHeight : height * 0.25,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.error, size: 100),
    );
  }

  Widget _buildAuthTabs() {
    return TabBar(
      dividerColor: Theme.of(context).colorScheme.secondary,
      indicatorSize: TabBarIndicatorSize.tab,
      controller: _tabController,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      tabs: const [
        Tab(
          child: Text(
            'Player',
            style: TextStyle(fontSize: _tabFontSize),
            semanticsLabel: 'Player Authentication',
          ),
        ),
        Tab(
          child: Text(
            'User',
            style: TextStyle(fontSize: _tabFontSize),
            semanticsLabel: 'User Authentication',
          ),
        ),
      ],
      onTap: _handleTabChange,
    );
  }
}
