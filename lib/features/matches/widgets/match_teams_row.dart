import 'package:flutter/material.dart';
import 'package:tracket/features/matches/models/match.dart';
import 'package:tracket/features/matches/models/match_team_info.dart';
import 'package:tracket/features/matches/widgets/team_column.dart';

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
      children: [
        // Team A
        _buildMatchTeamColumn(
          context,
          team: match.team1,
          isMatchStarted: match.status == MatchStatus.live ||
              match.status == MatchStatus.completed,
          isInningStarted: match.inning1Score != null,
          runs: match.inning1Score?.runs,
          wickets: match.inning1Score?.wickets,
          oversDisplay: match.inning1Score?.oversDisplay,
        ),

        // VS Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: versusBgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'VS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),

        // Team B
        _buildMatchTeamColumn(
          context,
          team: match.team2,
          isMatchStarted: match.status == MatchStatus.live ||
              match.status == MatchStatus.completed,
          isInningStarted: match.inning2Score != null,
          runs: match.inning2Score?.runs,
          wickets: match.inning2Score?.wickets,
          oversDisplay: match.inning2Score?.oversDisplay,
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
  }) {
    return Expanded(
      child: Column(
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
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '($oversDisplay)',
              style: TextStyle(
                color: Colors.grey[600],
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
      ),
    );
  }
}
