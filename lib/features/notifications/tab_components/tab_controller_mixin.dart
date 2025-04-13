import 'package:flutter/material.dart';
import 'package:tracket/features/notifications/tab_components/notification_tab_config.dart';

mixin TabControllerMixin<T extends StatefulWidget> on State<T> {
  late final TabController tabController;
  List<NotificationTabConfig> get tabConfigs;
  int get initialTabIndex => 0;
  double get tabHeight => 46.0;
  EdgeInsets get tabPadding =>
      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  Duration get animationDuration => const Duration(milliseconds: 250);

  bool get isScrollable => false;

  void initTabController(int length, {int initialIndex = 0}) {
    tabController = TabController(
      length: length,
      initialIndex: initialIndex,
      vsync: this as TickerProvider,
    );

    tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  /// Handler for tab changes - can be overridden by implementing class
  void _handleTabChange() {
    // By default, this just triggers a rebuild when tab changes
    if (tabController.indexIsChanging) {
      setState(() {});
    }
  }

  PreferredSizeWidget buildTabBar({
    Color? indicatorColor,
    Color? labelColor,
    Color? unselectedLabelColor,
    TabBarIndicatorSize indicatorSize = TabBarIndicatorSize.label,
    double indicatorWeight = 3.0,
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    EdgeInsets? labelPadding,
    Decoration? indicator,
    bool? enableFeedback,
  }) {
    return PreferredSize(
        preferredSize: Size.fromHeight(tabHeight),
        child: Builder(builder: (context) {
          final theme = Theme.of(context);

          // Use provided colors or fallback to theme colors
          final _indicatorColor = indicatorColor ?? theme.colorScheme.primary;
          final _labelColor = labelColor ?? theme.colorScheme.primary;
          final _unselectedLabelColor = unselectedLabelColor ??
              theme.colorScheme.onSurface.withValues(alpha: 0.7);
          final _labelStyle = labelStyle ??
              theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              );
          final _unselectedLabelStyle =
              unselectedLabelStyle ?? theme.textTheme.titleSmall;
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.3),
                  width: 1.0,
                ),
              ),
            ),
            child: TabBar(
              controller: tabController,
              isScrollable: isScrollable,
              indicatorColor: _indicatorColor,
              indicatorWeight: indicatorWeight,
              indicatorSize: indicatorSize,
              indicator: indicator,
              labelColor: _labelColor,
              unselectedLabelColor: _unselectedLabelColor,
              labelStyle: _labelStyle,
              unselectedLabelStyle: _unselectedLabelStyle,
              labelPadding: labelPadding ?? tabPadding,
              enableFeedback: enableFeedback ?? true,
              splashBorderRadius: BorderRadius.circular(8.0),
              tabs: _buildTabs(context),
            ),
          );
        }));
  }

  /// Builds the TabBarView with proper animation
  Widget buildTabBarView({
    required List<Widget> children,
    ScrollPhysics? physics,
    bool wantKeepAlive = true,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    assert(children.length == tabConfigs.length,
        'Number of children must match the number of tabs');

    return Padding(
      padding: padding,
      child: TabBarView(
        controller: tabController,
        physics: physics ?? const BouncingScrollPhysics(),
        children: children.map((child) {
          return wantKeepAlive ? KeepAliveWrapper(child: child) : child;
        }).toList(),
      ),
    );
  }

  /// Builds tab widgets with icon, text, and badge
  List<Widget> _buildTabs(BuildContext context) {
    final theme = Theme.of(context);

    return tabConfigs.map((config) {
      return Tab(
        height: tabHeight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with badge if needed
            if (config.icon != null) ...[
              _BadgedIcon(
                icon: config.icon,
                badge: config.badge,
                isSelected: tabController.index == tabConfigs.indexOf(config),
                theme: theme,
              ),
              const SizedBox(width: 8.0),
            ],
            // Tab text
            Text(config.text),
          ],
        ),
      );
    }).toList();
  }

  /// Gets the current tab index
  int get currentTabIndex => tabController.index;

  /// Animates to a specific tab
  void animateToTab(int index, {Duration? duration}) {
    if (index >= 0 && index < tabConfigs.length) {
      tabController.animateTo(
        index,
        duration: duration ?? animationDuration,
        curve: Curves.easeInOut,
      );
    }
  }
}

/// Custom widget for an icon with a badge
class _BadgedIcon extends StatelessWidget {
  final IconData? icon;
  final int? badge;
  final bool isSelected;
  final ThemeData theme;

  const _BadgedIcon({
    required this.icon,
    required this.badge,
    required this.isSelected,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          icon,
          size: 22.0,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        if (badge != null && badge! > 0)
          Positioned(
            top: -8,
            right: -8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Center(
                child: Text(
                  badge! > 99 ? '99+' : badge.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onError,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Widget to keep children alive when they're not visible
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _KeepAliveWrapperState createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
