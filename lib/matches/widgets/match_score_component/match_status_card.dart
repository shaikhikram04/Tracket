import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/current_over_indicator.dart';
import 'package:tracket/matches/widgets/match_score_component/current_players_info.dart';
import 'package:tracket/matches/widgets/match_score_component/match_header.dart';
import 'package:tracket/matches/widgets/match_teams_row.dart';
import 'package:tracket/utils/colors.dart';

class MatchStatusCard extends StatelessWidget {
  const MatchStatusCard({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: LightThemeColors.surfaceColor,
        border: Border(
          bottom: BorderSide(color: Colors.black12, width: 0.5),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isLightMode
              ? LightThemeColors.cardColor
              : DarkThemeColors.cardColor,
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
                remainingBalls: 0,
                showShadow: false,
                margin: null,
                bgColor: LightThemeColors.surfaceColor.withValues(alpha: 0.9),
              ),
              CurrentPlayersInfo(
                batsmen: match.currentBatsmen!,
                bowler: match.currentBowlers!,
                strikerIndex: match.strikerIndex,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
