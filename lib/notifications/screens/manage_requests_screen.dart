import 'package:flutter/material.dart';
import 'package:tracket/notifications/tab_components/base_tab_screen.dart';
import 'package:tracket/notifications/tab_components/notification_tab_config.dart';
import 'package:tracket/notifications/tab_components/tab_controller_mixin.dart';
import 'package:tracket/notifications/widgets/requests_fetcher.dart';

class ManageRequestsScreen extends BaseTabScreen {
  const ManageRequestsScreen({super.key, super.initialIndex, this.teamId});

  final String? teamId;

  @override
  State<ManageRequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<ManageRequestsScreen>
    with SingleTickerProviderStateMixin, TabControllerMixin {
  static const _tabs = [
    NotificationTabConfig(
      text: 'Received',
      icon: Icons.arrow_downward,
    ),
    NotificationTabConfig(
      text: 'Sent',
      icon: Icons.arrow_upward,
    ),
  ];

  @override
  void initState() {
    super.initState();
    initTabController(
      _tabs.length,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTabBar(tabs: _tabs),
        buildTabBarView(
          children: [
            RequestsFetcher(
              field: 'to',
              teamId: widget.teamId,
            ),
            RequestsFetcher(
              field: 'from',
              teamId: widget.teamId,
            ),
          ],
        ),
      ],
    );
  }
}
