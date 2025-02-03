import 'package:flutter/material.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/widgets/inning_scoreboard.dart';
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
          height: 500,
          child: TabBarView(
            controller: tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              InningScoreboard(inning: _mockFirstInnings()),
              InningScoreboard(inning: _mockSecondInnings()),
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
        bowlingStats: [
          BowlingScore(
            uuid: '',
            playerName: 'Bowler1',
            balls: 6,
            wickets: 0,
            runsGiven: 12,
            maidenOvers: 0,
          ),
          BowlingScore(
            uuid: '',
            playerName: 'Bowler2',
            balls: 12,
            wickets: 1,
            runsGiven: 15,
            maidenOvers: 0,
          ),
        ],
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
        bowlingStats: [],
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
      ); // Add second innings data
}
