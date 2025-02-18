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
  // Constants
  static const _kAnimationDuration = Duration(milliseconds: 180);
  static const _kTabRadius = 20.0;
  static const _kContentPadding = EdgeInsets.symmetric(horizontal: 20);
  static const _kVerticalSpacing = 24.0;

  late final TabController _tabController;
  bool _isChangingTab = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabAnimation);
  }

  void _handleTabAnimation() {
    if (!_tabController.indexIsChanging) return;
    _handleTabChange(_tabController.index);
  }

  Future<void> _handleTabChange(int index) async {
    if (_isChangingTab) return;

    setState(() => _isChangingTab = true);

    try {
      await Future.delayed(_kAnimationDuration);
      if (!mounted) return;

      ref.read(playerAuthProvider.notifier).reset();
      ref.read(authScreenSizeProvider.notifier).changeSizeByIndex(index);
    } catch (e) {
      if (mounted) {
        showSnackBar('Something went wrong. Please try again.', context);
      }
    } finally {
      if (mounted) {
        setState(() => _isChangingTab = false);
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabAnimation);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabBarViewHeight = ref.watch(authScreenSizeProvider);
    final safeAreaHeight = getSafeAreaHeight(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: safeAreaHeight),
            child: Padding(
              padding: _kContentPadding,
              child: Column(
                children: [
                  const SizedBox(height: _kVerticalSpacing),
                  _buildAnimatedLogo(),
                  const SizedBox(height: _kVerticalSpacing),
                  _buildAuthContainer(tabBarViewHeight),
                  const SizedBox(height: _kVerticalSpacing),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return Hero(
      tag: 'app_logo',
      child: const AppLogo(),
    );
  }

  Widget _buildAuthContainer(double height) {
    return AnimatedContainer(
      duration: _kAnimationDuration,
      decoration: BoxDecoration(
        color: LightThemeColors.surfaceColor,
        borderRadius: BorderRadius.circular(_kTabRadius),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTabs(),
          _buildAuthContent(height),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: LightThemeColors.secondaryText.withValues(alpha: 0.25),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(_kTabRadius),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: MyTextStyle(context).titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
        indicator: BoxDecoration(
          color: primaryColor,
          borderRadius: _getTabBorderRadius(),
        ),
        labelColor: LightThemeColors.surfaceColor,
        unselectedLabelColor: LightThemeColors.secondaryText,
        tabs: const [
          Tab(child: Text('Player')),
          Tab(child: Text('User')),
        ],
      ),
    );
  }

  BorderRadius _getTabBorderRadius() {
    return BorderRadius.vertical(
      top: const Radius.circular(_kTabRadius),
      bottom: Radius.circular(0),
    );
  }

  Widget _buildAuthContent(double height) {
    return AnimatedSwitcher(
      duration: _kAnimationDuration,
      child: SizedBox(
        height: height,
        child: _isChangingTab
            ? Center(child: _buildLoadingIndicator())
            : TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: const [
                  PlayerAuth(),
                  UserAuth(),
                ],
              ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
      strokeWidth: 3,
    );
  }
}
