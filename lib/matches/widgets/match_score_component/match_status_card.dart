import 'package:flutter/material.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/current_over_indicator.dart';
import 'package:tracket/matches/widgets/match_score_component/current_players_info.dart';
import 'package:tracket/matches/widgets/match_score_component/match_header.dart';
import 'package:tracket/matches/widgets/match_teams_row.dart';
import 'package:tracket/utils/colors.dart';

class MatchStatusCard extends StatelessWidget {
  const MatchStatusCard({
    super.key,
    required this.match,
    required this.inning1,
    required this.inning2,
  });

  final Match match;
  final Inning? inning1;
  final Inning? inning2;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isLightMode
            ? LightThemeColors.cardColor.withAlpha(150)
            : DarkThemeColors.cardColor.withAlpha(150),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MatchHeader(createdAt: match.createdAt, status: match.status),
          SizedBox(height: 16),
          MatchTeamsRow(
            inning1: inning1,
            inning2: inning2,
            status: match.status,
            team1: match.team1,
            team2: match.team2,
            versusBgColor: primaryLight.withValues(alpha: 0.2),
          ),
          if (match.status == MatchStatus.live) ...[
            CurrentOverIndicator(
              balls: match.currentOverRuns,
              isBlur: false,
              remainingBalls: match.inning1!.remainingBalls,
              showShadow: false,
              bgColor: LightThemeColors.surfaceColor.withValues(alpha: 0.9),
            ),
            CurrentPlayersInfo(
              batsmen: batsmen,
              bowler: bowler,
              strikerIndex: strikerIndex,
            ),
          ]
        ],
      ),
    );
  }
}
