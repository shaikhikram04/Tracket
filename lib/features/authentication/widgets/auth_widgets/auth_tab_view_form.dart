import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/features/authentication/widgets/auth_widgets/player_auth.dart';
import 'package:tracket/features/authentication/widgets/auth_widgets/user_auth.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/durations.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class AuthTabViewForm extends StatelessWidget {
  const AuthTabViewForm({
    super.key,
    required this.height,
    required this.isTabChanging,
    required this.tabController,
  });

  final double height;
  final bool isTabChanging;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return AnimatedSwitcher(
      duration: AppDuration.tabAnimationDuration,
      child: SizedBox(
        height: height,
        child: isTabChanging
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
                  controller: tabController,
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
