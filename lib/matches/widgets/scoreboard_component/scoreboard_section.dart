import 'package:flutter/material.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/widgets/scoreboard_component/match_scoreboard.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';

class ScoreboardSection extends StatelessWidget {
  const ScoreboardSection({
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 255, 250),
        border: Border.all(
          color: LightThemeColors.backgroundColor,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.elliptical(20, 10)),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 1)],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: getTitleText('Scoreboard', context),
          ),
          Scoreboard(
            inning1: inning1,
            inning2: inning2,
            team1Players: team1Players,
            team2Players: team2Players,
            team1: team1,
            team2: team2,
          ),
        ],
      ),
    );
  }
}
