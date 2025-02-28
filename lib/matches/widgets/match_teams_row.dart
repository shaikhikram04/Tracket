import 'package:flutter/material.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/widgets/team_column.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class MatchTeamsRow extends StatelessWidget {
  const MatchTeamsRow({
    super.key,
    required this.versusBgColor,
    required this.inning1,
    required this.inning2,
    required this.team1,
    required this.team2,
    required this.status,
  });

  final MatchTeamInfo team1;
  final MatchTeamInfo team2;
  final MatchStatus status;
  final Inning? inning1;
  final Inning? inning2;
  final Color versusBgColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Team A
        _buildMatchTeamColumn(
          context,
          team: team1,
          isMatchStarted:
              status == MatchStatus.live || status == MatchStatus.completed,
          isInningStarted: inning1 != null,
          runs: inning1?.runs,
          wickets: inning1?.wickets,
          oversDisplay: inning1?.oversDisplay,
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
          team: team2,
          isMatchStarted:
              status == MatchStatus.live || status == MatchStatus.completed,
          isInningStarted: inning2 != null,
          runs: inning2?.runs,
          wickets: inning2?.wickets,
          oversDisplay: inning2?.oversDisplay,
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
            textStyle: MyTextStyle(context).bodyLarge.copyWith(
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
              style: MyTextStyle(context).bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
        ],
      ),
    );
  }
}
