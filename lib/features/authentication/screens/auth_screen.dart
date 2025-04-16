import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/features/authentication/providers/auth_screen_size.dart';
import 'package:tracket/features/authentication/providers/auth_state_provider.dart';
import 'package:tracket/features/authentication/widgets/app_logo.dart';
import 'package:tracket/features/authentication/widgets/player_auth.dart';
import 'package:tracket/features/authentication/widgets/user_auth.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/durations.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/devices/devices_utility.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

//* Authentication screen that provides tabs for Player and User authentication
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
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
      await Future.delayed(AppDuration.tabAnimationDuration);
      if (!mounted) return;

      ref.read(playerAuthProvider.notifier).reset();
      ref.read(authScreenSizeProvider.notifier).changeSizeByIndex(index);
    } catch (e) {
      if (mounted) {
        THelperFunction.showSnackBar(
            'Something went wrong. Please try again.', context);
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
    final safeAreaHeight = TDeviceUtils.getSafeAreaHeight(context);

    return Scaffold(
      backgroundColor: LightThemeColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: safeAreaHeight),
            child: Padding(
              padding: TPadding.hPaddingMd,
              child: Column(
                children: [
                  const SizedBox(height: TSizes.verticalSpacingXl),
                  const AppLogo(),
                  const SizedBox(height: TSizes.verticalSpacingXl),
                  _buildAuthContainer(tabBarViewHeight),
                  const SizedBox(height: TSizes.verticalSpacingXl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthContainer(double height) {
    return AnimatedContainer(
      duration: AppDuration.tabAnimationDuration,
      decoration: BoxDecoration(
        color: LightThemeColors.surfaceColor,
        borderRadius: BorderRadius.circular(TSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: primaryLight.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 1,
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            LightThemeColors.cardColor,
            LightThemeColors.cardColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(TSizes.radiusMd),
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
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor,
              primaryMedium,
            ],
          ),
          borderRadius: _getTabBorderRadius(),
        ),
        labelColor: LightThemeColors.surfaceColor,
        unselectedLabelColor: LightThemeColors.secondaryText,
        overlayColor: WidgetStateColor.resolveWith(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return primaryLight.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.pressed)) {
              return primaryLight.withValues(alpha: 0.2);
            }
            return Colors.transparent;
          },
        ),
        tabs: const [
          Tab(child: Text('Player')),
          Tab(child: Text('User')),
        ],
      ),
    );
  }

  BorderRadius _getTabBorderRadius() {
    return const BorderRadius.vertical(
      top: Radius.circular(TSizes.radiusMd),
      bottom: Radius.circular(0),
    );
  }

  Widget _buildAuthContent(double height) {
    return AnimatedSwitcher(
      duration: AppDuration.tabAnimationDuration,
      child: SizedBox(
        height: height,
        child: _isChangingTab
            ? const Center(
                child: CircularLoadingIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryMedium),
                strokeWidth: 3,
              ))
            : Container(
                decoration: const BoxDecoration(
                  color: LightThemeColors.surfaceColor,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(TSizes.radiusMd),
                  ),
                ),
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: const [
                    PlayerAuth(),
                    UserAuth(),
                  ],
                ),
              ),
      ),
    );
  }
}
