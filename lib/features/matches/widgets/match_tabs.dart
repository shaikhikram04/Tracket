import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

// Tab data model for type safety and easy management
class MatchTabData {
  final String label;
  final int count;
  final bool isLive;

  const MatchTabData({
    required this.label,
    this.count = 0,
    this.isLive = false,
  });
}

class CricketMatchTabs extends StatefulWidget {
  const CricketMatchTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.isLoading = false,
  });

  final List<MatchTabData> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final bool isLoading;

  @override
  State<CricketMatchTabs> createState() => _CricketMatchTabsState();
}

class _CricketMatchTabsState extends State<CricketMatchTabs> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedTab() {
    if (!_scrollController.hasClients) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final double width = renderBox.size.width;

    // Calculate the ideal scroll position
    final double itemWidth = width / 3; // Approximate tab width
    final double targetScroll =
        (widget.selectedIndex * itemWidth) - (width / 3);

    _scrollController.animateTo(
      targetScroll.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(
            widget.tabs.length,
            (index) => _buildTab(index, isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, bool isDark) {
    final tab = widget.tabs[index];
    final isSelected = widget.selectedIndex == index;

    return GestureDetector(
      onTap: () {
        widget.onTabSelected(index);
        _scrollToSelectedTab();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: _getTabBackgroundColor(isSelected, tab.isLive),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getTabBorderColor(isSelected, tab.isLive),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isLoading && isSelected)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isSelected ? primaryColor : Colors.grey,
                      ),
                    ),
                  ),
                ),
              Text(
                tab.label,
                style: TextStyle(
                  color: _getTabTextColor(isSelected, tab.isLive, isDark),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              if (tab.count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getCounterBackgroundColor(isSelected, tab.isLive),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tab.count.toString(),
                    style: const TextStyle(
                      color: onPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              if (tab.isLive) ...[
                const SizedBox(width: 6),
                _buildLiveIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: StatusColors.liveMatch,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: StatusColors.liveMatch.withValues(alpha: 0.4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Color _getTabBackgroundColor(bool isSelected, bool isLive) {
    if (isLive && isSelected)
      return StatusColors.liveMatch.withValues(alpha: 0.1);
    if (isSelected) return primaryColor.withValues(alpha: 0.1);
    return Colors.transparent;
  }

  Color _getTabBorderColor(bool isSelected, bool isLive) {
    if (isLive && isSelected) return StatusColors.liveMatch;
    if (isSelected) return primaryColor;
    return Colors.grey.withValues(alpha: 0.3);
  }

  Color _getTabTextColor(bool isSelected, bool isLive, bool isDark) {
    if (isLive && isSelected) return StatusColors.liveMatch;
    if (isSelected) return isDark ? primaryLight : primaryColor;
    return isDark
        ? DarkThemeColors.secondaryText
        : LightThemeColors.secondaryText;
  }

  Color _getCounterBackgroundColor(bool isSelected, bool isLive) {
    if (isLive) return StatusColors.liveMatch;
    if (isSelected) return primaryColor;
    return Colors.grey;
  }
}
