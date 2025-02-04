import 'package:flutter/material.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/widgets/scoreboard_component/inning_scoreboard.dart';
import 'package:tracket/notifications/tab_components/base_tab_screen.dart';
import 'package:tracket/notifications/tab_components/notification_tab_config.dart';
import 'package:tracket/notifications/tab_components/tab_controller_mixin.dart';

class Scoreboard extends BaseTabScreen {
  const Scoreboard({
    super.key,
    required this.inning1,
    required this.inning2,
  });

  final Inning? inning1;
  final Inning? inning2;

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard>
    with SingleTickerProviderStateMixin, TabControllerMixin {
  static const _tabs = [
    NotificationTabConfig(text: 'Team1 Inning'),
    NotificationTabConfig(text: 'Team2 Inning'),
  ];

  @override
  void initState() {
    super.initState();
    initTabController(_tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTabBar(tabs: _tabs),
        const SizedBox(height: 8),
        SizedBox(
          height: 495,
          child: TabBarView(
            controller: tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              widget.inning1 != null
                  ? InningScoreboard(inning: widget.inning1!)
                  : Container(),
              widget.inning2 != null
                  ? InningScoreboard(inning: widget.inning2!)
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
