import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/authentication/providers/auth_screen_size.dart';
import 'package:tracket/authentication/providers/auth_state_provider.dart';
import 'package:tracket/authentication/widgets/app_logo.dart';
import 'package:tracket/authentication/widgets/player_auth.dart';
import 'package:tracket/authentication/widgets/user_auth.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';

//* Authentication screen that provides tabs for Player and User authentication
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const int _tabSwitchDelay = 180;
  static const double _bottomPadding = 40.0;
  static const EdgeInsets _horizontalPadding =
      EdgeInsets.symmetric(horizontal: 17);

  bool _isChangingTab = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _handleTabChange(int index) async {
    try {
      if (_tabController.indexIsChanging) {
        setState(() => _isChangingTab = true);
        await Future.delayed(const Duration(milliseconds: _tabSwitchDelay));
        ref.read(playerAuthProvider.notifier).reset();
        ref.read(authScreenSizeProvider.notifier).changeSizeByIndex(index);
        setState(() => _isChangingTab = false);
      }
    } catch (e) {
      setState(() => _isChangingTab = false);
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
    final tabBarViewHeight = ref.watch(authScreenSizeProvider);
    final safeAreaHeight = getSafeAreaHeight(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              authGredientStart,
              authGredientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: safeAreaHeight),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const AppLogo(),
                  const SizedBox(height: 24),
                  Padding(
                    padding: _horizontalPadding,
                    child: Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: blackColor.withValues(alpha: 0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          //* TabBar for show option of user & player authentication
                          _buildAuthTabs(),
                          //* Content of TabBar for signup/login user or player
                          _buildTabBarView(tabBarViewHeight)
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
      ),
    );
  }

  Widget _buildTabBarView(double height) {
    return SizedBox(
      height: height,
      child: _isChangingTab
          ? getCircleLoadingIndicator()
          : TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: const [
                PlayerAuth(),
                UserAuth(),
              ],
            ),
    );
  }

  Widget _buildAuthTabs() {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: TabBar(
        dividerColor: transparentColor,
        indicatorSize: TabBarIndicatorSize.tab,
        controller: _tabController,
        indicator: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12).copyWith(
            bottomLeft: _tabController.index == 0 ? Radius.circular(0) : null,
            bottomRight: _tabController.index == 0 ? null : Radius.circular(0),
          ),
        ),
        labelStyle: MyTextStyle(context).titleMedium,
        labelColor: whiteColor,
        unselectedLabelColor: darkGrey,
        tabs: const [
          Tab(
            child: Text('Player'),
          ),
          Tab(
            child: Text('User'),
          ),
        ],
        onTap: _handleTabChange,
      ),
    );
  }
}
