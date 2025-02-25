import 'package:flutter/material.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/widgets/match_squad.dart';
import 'package:tracket/matches/widgets/scoreboard_component/inning_scoreboard.dart';
import 'package:tracket/notifications/tab_components/base_tab_screen.dart';
import 'package:tracket/notifications/tab_components/notification_tab_config.dart';
import 'package:tracket/notifications/tab_components/tab_controller_mixin.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';

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
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              LightThemeColors.cardColor.withOpacity(0.5),
              LightThemeColors.backgroundColor,
            ],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(20, 10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 1,
              spreadRadius: 1,
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            buildTabBar(),
            const SizedBox(height: 8),
            _buildTabContent(constraints),
          ],
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(child: getTitleText('Scoreboard', context)),
    );
  }

  Widget _buildTabContent(BoxConstraints constraints) {
    // Calculate a more responsive height based on screen size
    final screenHeight = constraints.maxHeight;
    final availableHeight = screenHeight > 600
        ? screenHeight * 0.6 // Use 60% of available height on larger screens
        : screenHeight * 0.75; // Use 75% of available height on smaller screens

    // Cap the height to reasonable values
    final contentHeight = availableHeight.clamp(400.0, 600.0);

    return Container(
      constraints: BoxConstraints(
        minHeight: 400,
        maxHeight: contentHeight,
      ),
      child: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildTeamContent(
            inning: widget.inning1,
            team: widget.team1,
            players: widget.team1Players,
          ),
          _buildTeamContent(
            inning: widget.inning2,
            team: widget.team2,
            players: widget.team2Players,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamContent({
    required Inning? inning,
    required MatchTeamInfo team,
    required List<MatchPlayerInfo> players,
  }) {
    if (inning != null) {
      return InningScoreboard(
        battingScores: inning.battingStats,
        extras: inning.extras,
        bowlingStats: inning.bowlingStats,
        fallOfWickets: inning.fallOfWickets,
        overs: inning.oversDisplay,
        teamName: team.teamName,
        totalScore: inning.runs,
        wickets: inning.wickets,
      );
    } else {
      return MatchSquad(
        selectedPlayers: players,
        captainId: team.captainId,
        wicketkeeperId: team.wicketkeeperId,
        isPlayerCanAdd: false,
        titleFontSize: 17,
        title: '${team.teamName} Squad',
        isLongCricketRole: true,
      );
    }
  }
}
