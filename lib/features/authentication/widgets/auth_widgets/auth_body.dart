import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/authentication/providers/auth_screen_size.dart';
import 'package:tracket/features/authentication/providers/auth_state_provider.dart';
import 'package:tracket/features/authentication/widgets/auth_widgets/auth_tab_bar.dart';
import 'package:tracket/features/authentication/widgets/auth_widgets/auth_tab_view_form.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/durations.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class AuthBody extends ConsumerStatefulWidget {
  const AuthBody({super.key});

  @override
  ConsumerState<AuthBody> createState() => _AuthBodyState();
}

class _AuthBodyState extends ConsumerState<AuthBody> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isChangingTab = false;

  // Declare cancellable future to handle tab change
  Future<void>? _tabChangeFuture;

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
    // Prevent multiple simultaneous tab changes
    if (_isChangingTab) return;

    setState(() => _isChangingTab = true);

    try {
      // Cancel any previous tab change operation
      _tabChangeFuture?.ignore();

      // Create new tab change operation
      _tabChangeFuture = Future.delayed(AppDuration.tabAnimationDuration);
      await _tabChangeFuture;

      if (!mounted) return;

      // Reset auth state and update screen size
      ref.read(playerAuthProvider.notifier).reset();
      ref.read(authScreenSizeProvider.notifier).changeSizeByIndex(index);
    } catch (e) {
      if (mounted) {
        THelperFunction.showErrorSnackBar(TTextStrings.somethingWentWrong, context);
      }
    } finally {
      if (mounted) {
        setState(() => _isChangingTab = false);
      }
    }
  }

  @override
  void dispose() {
    // Cancel any pending operations
    _tabChangeFuture?.ignore();
    _tabController.removeListener(_handleTabAnimation);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);
    final tabBarViewHeight = ref.watch(authScreenSizeProvider);

    return AnimatedContainer(
      duration: AppDuration.tabAnimationDuration,
      decoration: BoxDecoration(
        color: isDark ? DarkThemeColors.surfaceColor : LightThemeColors.surfaceColor,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusXl),
        boxShadow: _buildBoxShadow(),
      ),
      child: Column(
        children: [
          AuthTabBar(tabController: _tabController),
          AuthTabViewForm(
            height: tabBarViewHeight,
            isTabChanging: _isChangingTab,
            tabController: _tabController,
          ),
        ],
      ),
    );
  }

  List<BoxShadow> _buildBoxShadow() {
    return [
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
    ];
  }
}
