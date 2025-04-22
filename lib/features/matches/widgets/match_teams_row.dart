import 'package:flutter/material.dart';
import 'package:tracket/features/matches/models/match.dart';
import 'package:tracket/features/matches/models/match_team_info.dart';
import 'package:tracket/features/matches/widgets/team_column.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class MatchTeamsRow extends StatelessWidget {
  const MatchTeamsRow({
    super.key,
    required this.versusBgColor,
    required this.match,
  });

  final Match match;
  final Color versusBgColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        // Team A
        Expanded(
          child: _buildMatchTeamColumn(
            context,
            team: match.team1,
            isMatchStarted: match.status == MatchStatus.live ||
                match.status == MatchStatus.completed,
            isInningStarted: match.inning1Score != null,
            runs: match.inning1Score?.runs,
            wickets: match.inning1Score?.wickets,
            oversDisplay: match.inning1Score?.oversDisplay,
            alignment: CrossAxisAlignment.center,
          ),
        ),

        // VS Badge
        Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: versusBgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'VS',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontSize: 12),
          ),
        ),

        // Team B
        Expanded(
          child: _buildMatchTeamColumn(
            context,
            team: match.team2,
            isMatchStarted: match.status == MatchStatus.live ||
                match.status == MatchStatus.completed,
            isInningStarted: match.inning2Score != null,
            runs: match.inning2Score?.runs,
            wickets: match.inning2Score?.wickets,
            oversDisplay: match.inning2Score?.oversDisplay,
            alignment: CrossAxisAlignment.center,
          ),
        ),
      ],
    );
  }

  Widget _buildMatchTeamColumn(
    BuildContext context, {
    required MatchTeamInfo team,
    required bool isMatchStarted,
    required bool isInningStarted,
    required int? runs,
    required int? wickets,
    required String? oversDisplay,
    required CrossAxisAlignment alignment,
  }) {
    final isDark = THelperFunction.isDarkMode(context);
    return Column(
      crossAxisAlignment: alignment,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TeamColumn(
          teamName: team.teamName,
          teamLogo: team.logoUrl,
          textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 8),
        if (isInningStarted) ...[
          Text(
            '$runs/$wickets',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? primaryLight : primaryColor,
            ),
          ),
          Text(
            '($oversDisplay)',
            style: TextStyle(
              color: isDark
                  ? DarkThemeColors.primaryText
                  : LightThemeColors.secondaryText,
              fontSize: 14,
            ),
          ),
        ],
        if (!isInningStarted && isMatchStarted)
          Text(
            'Yet to bat',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
      ],
    );
  }
}
