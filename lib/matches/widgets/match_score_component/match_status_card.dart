import 'package:flutter/material.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
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
    required this.batsmen,
    required this.bowler,
  });

  final Match match;
  final List<BattingScore> batsmen;
  final int strikerIndex;
  final BowlingScore bowler;

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
          MatchHeader(match: match),
          SizedBox(height: 16),
          MatchTeamsRow(
            match: match,
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
