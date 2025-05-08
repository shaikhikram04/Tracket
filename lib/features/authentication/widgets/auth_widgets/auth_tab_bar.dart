import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class AuthTabBar extends StatelessWidget {
  const AuthTabBar({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(TSizes.borderRadiusXl)),
      ),
      child: TabBar(
        controller: tabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, primaryMedium],
          ),
          borderRadius: _getTabBorderRadius(),
        ),
        labelColor: onPrimary,
        unselectedLabelColor: isDark ? DarkThemeColors.secondaryText : LightThemeColors.secondaryText,
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
}
