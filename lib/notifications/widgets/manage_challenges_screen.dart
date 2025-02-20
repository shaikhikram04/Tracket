import 'package:flutter/material.dart';
import 'package:tracket/notifications/tab_components/base_tab_screen.dart';
import 'package:tracket/notifications/tab_components/notification_tab_config.dart';
import 'package:tracket/notifications/tab_components/tab_controller_mixin.dart';
import 'package:tracket/notifications/widgets/challenges_fetcher.dart';

class ManageChallengesScreen extends BaseTabScreen {
  const ManageChallengesScreen({super.key, this.teamId});

  final String? teamId;

  @override
  State<ManageChallengesScreen> createState() => _ManageChallengesScreenState();
}

class _ManageChallengesScreenState extends State<ManageChallengesScreen>
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTabBar(tabs: _tabs),
        buildTabBarView(
          children: [
            ChallengesFetcher(field: 'to', teamId: widget.teamId),
            ChallengesFetcher(field: 'from', teamId: widget.teamId),
          ],
        ),
      ],
    );
  }
}
