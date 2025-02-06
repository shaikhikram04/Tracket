import 'package:flutter/material.dart';
import 'package:tracket/notifications/tab_components/notification_tab_config.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

mixin TabControllerMixin<T extends StatefulWidget> on State<T> {
  late final TabController tabController;

  void initTabController(int length, {int initialIndex = 0}) {
    tabController = TabController(
      length: length,
      initialIndex: initialIndex,
      vsync: this as TickerProvider,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget buildTabBar({
    required List<NotificationTabConfig> tabs,
    Color? selectedColor,
    Color? unselectedColor,
  }) {
    final theme = Theme.of(context);

    return TabBar(
      dividerColor: theme.colorScheme.secondary,
      indicatorSize: TabBarIndicatorSize.tab,
      controller: tabController,
      unselectedLabelColor: unselectedColor ?? unSelectColor,
      labelColor: selectedColor ?? darkGreenColor,
      labelStyle: MyTextStyle(context)
                  .bodyLarge
                  .copyWith(fontWeight: FontWeight.bold),
      unselectedLabelStyle: MyTextStyle(context).bodyLarge,
      tabs: tabs
          .map((config) => Tab(
                text: config.text,
                icon: config.icon != null ? Icon(config.icon) : null,
                child: config.badge != null
                    ? Badge(
                        label: Text('${config.badge}'),
                        child: Text(config.text),
                      )
                    : null,
              ))
          .toList(),
    );
  }

  Widget buildTabBarView({
    required List<Widget> children,
  }) {
    return Expanded(
      child: TabBarView(
        controller: tabController,
        children: children,
      ),
    );
  }
}
