import 'package:flutter/material.dart';
import 'package:tracket/features/matches/widgets/team_column.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';

class TeamSection extends StatelessWidget {
  const TeamSection({
    super.key,
    required this.team1Name,
    required this.team1Logo,
    required this.team2Name,
    required this.team2Logo,
    this.vsText = 'v/s',
  });

  final String team1Name;
  final String team1Logo;
  final String team2Name;
  final String team2Logo;
  final String vsText;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          getTitleText('Teams', context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TeamColumn(teamName: team1Name, teamLogo: team1Logo),
              Text(
                vsText,
                style: MyTextStyle(context)
                    .bodyLarge
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              TeamColumn(teamName: team2Name, teamLogo: team2Logo),
            ],
          ),
        ],
      ),
    );
  }
}
