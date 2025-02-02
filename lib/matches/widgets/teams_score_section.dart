import 'package:flutter/material.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';

class TeamsScoreSection extends StatelessWidget {
  const TeamsScoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTeamScore(
          context,
          teamName: 'Team A',
          score: '121/5',
          overs: '10',
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
          teamName: 'Team B',
          score: '50/2',
          overs: '6.5',
          isFirst: false,
        ),
      ],
    );
  }

  Widget _buildTeamScore(
    BuildContext context, {
    required String teamName,
    required String score,
    required String overs,
    required bool isFirst,
  }) {
    return Expanded(
      child: Row(
        textDirection: isFirst ? TextDirection.ltr : TextDirection.rtl,
        children: [
          Column(
            children: [
              getCircleAvatar(url: '', isTeam: true, radius: 30),
              const SizedBox(height: 4),
              Text(
                teamName,
                style: MyTextStyle(context).bodyLarge,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment:
                isFirst ? CrossAxisAlignment.start : CrossAxisAlignment.end,
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
