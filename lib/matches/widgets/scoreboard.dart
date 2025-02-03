import 'package:flutter/material.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match_team_info.dart';
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
          height: 400,
          child: TabBarView(
            controller: tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              BattingScorecard(innings: _mockFirstInnings()),
              BattingScorecard(innings: _mockSecondInnings()),
            ],
          ),
        ),
      ],
    );
  }

  Inning _mockFirstInnings() => Inning(
        battingStats: [
          BattingScore(
            playerName: 'Batsman1 name',
            runs: 7,
            ballsFaced: 9,
            fours: 1,
            sixes: 0,
            uuid: '',
          ),
          BattingScore(
            playerName: 'Batsman2 name',
            runs: 20,
            ballsFaced: 14,
            fours: 2,
            sixes: 0,
            uuid: '',
          ),
          BattingScore(
            playerName: 'Batsman3 name',
            runs: 20,
            ballsFaced: 14,
            fours: 2,
            sixes: 0,
            uuid: '',
          ),
        ],
        battingTeam: MatchTeamInfo(
          teamId: '',
          captainId: '',
          logoUrl: '',
          shortName: '',
          teamName: '',
          wicketkeeperId: '',
        ),
        bowlingTeam: MatchTeamInfo(
            teamId: '',
            captainId: '',
            logoUrl: '',
            shortName: '',
            teamName: '',
            wicketkeeperId: ''),
        bowlingStats: [],
      );

  Inning _mockSecondInnings() => Inning(
        battingStats: [
          BattingScore(
            playerName: 'Batsman1 name',
            runs: null,
            ballsFaced: null,
            fours: null,
            sixes: null,
            uuid: '',
          ),
          BattingScore(
            playerName: 'Batsman2 name',
            runs: null,
            ballsFaced: null,
            fours: null,
            sixes: null,
            uuid: '',
          ),
          BattingScore(
            playerName: 'Batsman3 name',
            runs: null,
            ballsFaced: null,
            fours: null,
            sixes: null,
            uuid: '',
          ),
        ],
        battingTeam: MatchTeamInfo(
          teamId: '',
          captainId: '',
          logoUrl: '',
          shortName: '',
          teamName: '',
          wicketkeeperId: '',
        ),
        bowlingTeam: MatchTeamInfo(
            teamId: '',
            captainId: '',
            logoUrl: '',
            shortName: '',
            teamName: '',
            wicketkeeperId: ''),
        bowlingStats: [],
      ); // Add second innings data
}
