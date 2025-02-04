import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';

class TeamsScoreSection extends StatelessWidget {
  const TeamsScoreSection({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTeamScore(
          context,
          teamName: match.team1.teamName,
          teamLogo: match.team1.logoUrl,
          score: '${match.inning1!.runs}/${match.inning1!.wickets}',
          overs: match.inning1!.oversDisplay,
          isFirst: true,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'vs',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        _buildTeamScore(
          context,
          teamName: match.team2.teamName,
          teamLogo: match.team2.logoUrl,
          score: match.inning2 == null
              ? null
              : '${match.inning2!.runs}/${match.inning2!.wickets}',
          overs: match.inning2 == null ? null : match.inning2?.oversDisplay,
          isFirst: false,
        ),
      ],
    );
  }

  Widget _buildTeamScore(
    BuildContext context, {
    required String teamName,
    required String teamLogo,
    required String? score,
    required String? overs,
    required bool isFirst,
  }) {
    return Expanded(
      child: Row(
        textDirection: isFirst ? TextDirection.ltr : TextDirection.rtl,
        children: [
          Column(
            children: [
              getCircleAvatar(url: teamLogo, isTeam: true, radius: 30),
              const SizedBox(height: 4),
              Text(
                teamName,
                style: MyTextStyle(context).bodyLarge,
              ),
            ],
          ),
          const SizedBox(width: 12),
          score == null
              ? Text('Yet to bat', style: MyTextStyle(context).boldBodyLarge)
              : Column(
                  crossAxisAlignment: isFirst
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Text(
                      score,
                      style: MyTextStyle(context).titleLarge,
                    ),
                    Text(
                      '$overs overs',
                      style: MyTextStyle(context).coloredBodyMedium(
                        Colors.grey[600]!,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
