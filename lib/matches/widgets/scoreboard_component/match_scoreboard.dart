import 'package:flutter/material.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/widgets/match_squad.dart';
import 'package:tracket/matches/widgets/scoreboard_component/inning_scoreboard.dart';
import 'package:tracket/notifications/tab_components/base_tab_screen.dart';
import 'package:tracket/notifications/tab_components/notification_tab_config.dart';
import 'package:tracket/notifications/tab_components/tab_controller_mixin.dart';

class Scoreboard extends BaseTabScreen {
  const Scoreboard({
    super.key,
    required this.inning1,
    required this.inning2,
    required this.team1Players,
    required this.team2Players,
    required this.team1,
    required this.team2,
  });

  final Inning? inning1;
  final Inning? inning2;
  final List<MatchPlayerInfo> team1Players;
  final List<MatchPlayerInfo> team2Players;
  final MatchTeamInfo team1;
  final MatchTeamInfo team2;

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard>
    with SingleTickerProviderStateMixin, TabControllerMixin {
  @override
  List<NotificationTabConfig> get tabConfigs => [
        NotificationTabConfig(text: 'Team1 Inning',),
        NotificationTabConfig(text: 'Team2 Inning'),
      ];
  

  @override
  void initState() {
    super.initState();
    initTabController(tabConfigs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTabBar(),
        const SizedBox(height: 10),
        SizedBox(
          height: 495,
          child: TabBarView(
            controller: tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              widget.inning1 != null
                  ? InningScoreboard(inning: widget.inning1!)
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: MatchSquad(
                        selectedPlayers: widget.team1Players,
                        captainId: widget.team1.captainId,
                        wicketkeeperId: widget.team1.wicketkeeperId,
                        isPlayerCanAdd: false,
                        titleFontSize: 17,
                        title: '${widget.team1.teamName} Squad',
                        isLongCricketRole: true,
                      ),
                    ),
              widget.inning2 != null
                  ? InningScoreboard(inning: widget.inning2!)
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: MatchSquad(
                        selectedPlayers: widget.team2Players,
                        captainId: widget.team2.captainId,
                        wicketkeeperId: widget.team2.wicketkeeperId,
                        isPlayerCanAdd: false,
                        titleFontSize: 17,
                        title: '${widget.team2.teamName}  Squad',
                        isLongCricketRole: true,
                      ),
                    ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
