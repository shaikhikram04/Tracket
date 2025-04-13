import 'package:flutter/material.dart';
import 'package:tracket/features/matches/models/match_player_info.dart';
import 'package:tracket/features/matches/models/match_team_info.dart';
import 'package:tracket/features/matches/widgets/scoreboard_component/inning_scoreboard.dart';
import 'package:tracket/features/notifications/tab_components/base_tab_screen.dart';
import 'package:tracket/features/notifications/tab_components/notification_tab_config.dart';
import 'package:tracket/features/notifications/tab_components/tab_controller_mixin.dart';

class Scoreboard extends BaseTabScreen {
  const Scoreboard({
    super.key,
    required this.matchId,
    required this.team1Players,
    required this.team2Players,
    required this.team1,
    required this.team2,
  });

  final String matchId;
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
        NotificationTabConfig(
          text: widget.team1.teamName,
          icon: Icons.sports_cricket,
        ),
        NotificationTabConfig(
          text: widget.team2.teamName,
          icon: Icons.sports_cricket,
        ),
      ];

  @override
  void initState() {
    super.initState();
    initTabController(tabConfigs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildTabBar(),
        const SizedBox(height: 8),
        _buildTabContent(widget.matchId),
      ],
    );
  }

  Widget _buildTabContent(String matchId) {
    return IndexedStack(
      index: tabController.index,
      children: [
        _buildTeamContent(
          team: widget.team1,
          players: widget.team1Players,
          inningNumber: 1,
        ),
        _buildTeamContent(
          team: widget.team2,
          players: widget.team2Players,
          inningNumber: 2,
        ),
      ],
    );
  }

  Widget _buildTeamContent({
    required int inningNumber,
    required MatchTeamInfo team,
    required List<MatchPlayerInfo> players,
  }) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: InningScoreboard(
        matchId: widget.matchId,
        inningNumber: inningNumber,
        teamName: team.teamName,
        captainId: team.captainId,
        wicketkeeperId: team.wicketkeeperId,
        players: players,
      ),
    );
  }
}
