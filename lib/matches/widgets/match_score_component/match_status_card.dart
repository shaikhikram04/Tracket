import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/widgets/match_score_component/current_over_fetcher.dart';
import 'package:tracket/matches/widgets/match_score_component/match_header.dart';
import 'package:tracket/matches/widgets/match_teams_row.dart';
import 'package:tracket/utils/colors.dart';

class MatchStatusCard extends StatelessWidget {
  const MatchStatusCard({
    super.key,
    required this.match,
  });

  final Match match;

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
          const SizedBox(height: 16),
          MatchTeamsRow(
            match: match,
            versusBgColor: primaryLight.withValues(alpha: 0.2),
          ),
          if (match.status == MatchStatus.live) ...[
            const SizedBox(height: 10),
            CurrentOverFetcher(
              matchId: match.id,
            ),
            // CurrentPlayersInfo(
            //   batsmen: batsmen,
            //   bowler: bowler,
            //   strikerIndex: strikerIndex,
            // ),
          ]
        ],
      ),
    );
  }
}
