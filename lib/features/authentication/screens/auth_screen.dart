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
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/devices/devices_utility.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

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
        THelperFunction.showSnackBar(TTextStrings.somethingWentWrong, context);
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: safeAreaHeight),
            child: Padding(
              padding: TPadding.hPaddingMd,
              child: Column(
                children: [
                  const SizedBox(height: TSizes.verticalSpacingMd),
                  const AppLogo(),
                  const SizedBox(height: TSizes.verticalSpacingMd),
                  _buildAuthContainer(tabBarViewHeight),
                  const SizedBox(height: TSizes.verticalSpacingMd),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthContainer(double height) {
    final isDark = THelperFunction.isDarkMode(context);

    return AnimatedContainer(
      duration: AppDuration.tabAnimationDuration,
      decoration: BoxDecoration(
        color: isDark
            ? DarkThemeColors.surfaceColor
            : LightThemeColors.surfaceColor,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.15),
            blurRadius: TSizes.blurRadiusXl,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: primaryLight.withValues(alpha: 0.08),
            blurRadius: TSizes.blurRadiusLg,
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
    final isDark = THelperFunction.isDarkMode(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark ? DarkThemeColors.cardColor : LightThemeColors.cardColor,
            isDark
                ? DarkThemeColors.cardColor.withValues(alpha: 0.8)
                : LightThemeColors.cardColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(TSizes.borderRadiusXl),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
        labelColor: onPrimary,
        unselectedLabelColor: isDark
            ? DarkThemeColors.secondaryText
            : LightThemeColors.secondaryText,
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
          Tab(child: Text(TTextStrings.player)),
          Tab(child: Text(TTextStrings.user)),
        ],
      ),
    );
  }

  BorderRadius _getTabBorderRadius() {
    return const BorderRadius.vertical(
      top: Radius.circular(TSizes.borderRadiusXl),
      bottom: Radius.circular(0),
    );
  }

  Widget _buildAuthContent(double height) {
    final isDark = THelperFunction.isDarkMode(context);
    return AnimatedSwitcher(
      duration: AppDuration.tabAnimationDuration,
      child: SizedBox(
        height: height,
        child: _isChangingTab
            ? const CircularLoadingIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryMedium),
                strokeWidth: TSizes.loadingStrokeWidthMd,
              )
            : Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? DarkThemeColors.surfaceColor
                      : LightThemeColors.surfaceColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(TSizes.borderRadiusXl),
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
