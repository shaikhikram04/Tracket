import 'package:flutter/material.dart';
import 'package:tracket/notifications/widgets/manage_challenges_screen.dart';
import 'package:tracket/notifications/widgets/manage_requests_screen.dart';
import 'package:tracket/notifications/tab_components/base_tab_screen.dart';
import 'package:tracket/notifications/tab_components/notification_tab_config.dart';
import 'package:tracket/notifications/tab_components/tab_controller_mixin.dart';
import 'package:tracket/notifications/widgets/notifications_fetcher.dart';

class NotificationsScreen extends BaseTabScreen {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin, TabControllerMixin {
  static const _tabs = [
    NotificationTabConfig(text: 'All'),
    NotificationTabConfig(text: 'Requests'),
    NotificationTabConfig(text: 'Challenge'),
  ];

  @override
  void initState() {
    super.initState();
    initTabController(_tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Column(
        children: [
          buildTabBar(tabs: _tabs),
          buildTabBarView(
            children: const [
              NotificationsFetcher(),
              ManageRequestsScreen(),
              ManageChallengesScreen(),
            ],
          ),
        ],
      ),
    );
  }
}
