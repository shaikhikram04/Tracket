import 'package:flutter/material.dart';
import 'package:tracket/matches/models/inning_data.dart';
import 'package:tracket/matches/widgets/batting_scorecard.dart';
import 'package:tracket/notifications/tab_components/base_tab_screen.dart';
import 'package:tracket/notifications/tab_components/notification_tab_config.dart';
import 'package:tracket/notifications/tab_components/tab_controller_mixin.dart';

class Scoreboard extends BaseTabScreen {
  const Scoreboard({super.key});

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
          height: 200,
          child: TabBarView(
            controller: tabController,
            children: [
              BattingScorecard(innings: _mockFirstInnings()),
              BattingScorecard(innings: _mockSecondInnings()),
            ],
          ),
        ),
      ],
    );
  }

  InningsData _mockFirstInnings() => InningsData(
        batsmen: [
          BatsmanData(
            name: 'Batsman1 name',
            dismissalInfo: 'c fielder1   b fielder2',
            runs: 7,
            balls: 9,
            fours: 1,
            sixes: 0,
            strikeRate: 80.64,
          ),
          BatsmanData(
            name: 'Batsman2 name',
            dismissalInfo: 'Not out',
            runs: 20,
            balls: 14,
            fours: 2,
            sixes: 0,
            strikeRate: 117.54,
          ),
          BatsmanData(
            name: 'Batsman3 name',
            dismissalInfo: 'Not out',
            runs: 20,
            balls: 14,
            fours: 2,
            sixes: 0,
            strikeRate: 117.54,
          ),
        ],
      );

  InningsData _mockSecondInnings() =>
      InningsData(batsmen: []); // Add second innings data
}
