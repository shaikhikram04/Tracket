import 'package:flutter/material.dart';
import 'package:tracket/features/home/utils/constants.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class TBottomNavigationBar extends StatelessWidget {
  const TBottomNavigationBar({super.key, required this.navigationIndex, required this.onTap});

  final int navigationIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: TSizes.blurRadiusMd, spreadRadius: 2),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: navigationIndex,
        onTap: onTap,
        items: HomeConstants.navigationItems,
        selectedItemColor: primaryColor,
        unselectedItemColor: isDark ? Colors.white70 : Colors.black54,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}
