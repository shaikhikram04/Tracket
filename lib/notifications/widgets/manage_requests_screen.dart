import 'package:flutter/material.dart';
import 'package:tracket/notifications/tab_components/base_tab_screen.dart';
import 'package:tracket/notifications/tab_components/notification_tab_config.dart';
import 'package:tracket/notifications/tab_components/tab_controller_mixin.dart';
import 'package:tracket/notifications/widgets/requests_fetcher.dart';

class ManageRequestsScreen extends BaseTabScreen {
  const ManageRequestsScreen({super.key, this.teamId});

  final String? teamId;

  @override
  State<ManageRequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<ManageRequestsScreen>
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
        ),
      ],
    );
  }
}
