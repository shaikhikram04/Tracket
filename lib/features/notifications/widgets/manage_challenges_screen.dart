import 'package:flutter/material.dart';
import 'package:tracket/features/notifications/tab_components/base_tab_screen.dart';
import 'package:tracket/features/notifications/tab_components/notification_tab_config.dart';
import 'package:tracket/features/notifications/tab_components/tab_controller_mixin.dart';
import 'package:tracket/features/notifications/widgets/challenges_fetcher.dart';

class ManageChallengesScreen extends BaseTabScreen {
  const ManageChallengesScreen({super.key, this.teamId});

  final String? teamId;

  @override
  State<ManageChallengesScreen> createState() => _ManageChallengesScreenState();
}

class _ManageChallengesScreenState extends State<ManageChallengesScreen>
    with SingleTickerProviderStateMixin, TabControllerMixin {
  @override
  List<NotificationTabConfig> get tabConfigs => [
        const NotificationTabConfig(
          text: 'Received',
          icon: Icons.arrow_downward,
        ),
        const NotificationTabConfig(
          text: 'Sent',
          icon: Icons.arrow_upward,
        ),
      ];

  @override
  void initState() {
    super.initState();
    initTabController(
      tabConfigs.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTabBar(),
        Expanded(
          child: buildTabBarView(
            children: [
              ChallengesFetcher(field: 'to', teamId: widget.teamId),
              ChallengesFetcher(field: 'from', teamId: widget.teamId),
            ],
          ),
        ),
      ],
    );
  }
}
