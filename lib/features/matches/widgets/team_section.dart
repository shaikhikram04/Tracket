import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';
import 'package:tracket/features/matches/widgets/team_column.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class TeamSection extends StatelessWidget {
  const TeamSection({
    super.key,
    required this.team1Name,
    required this.team1Logo,
    required this.team2Name,
    required this.team2Logo,
    this.vsText = TTextStrings.vs,
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
          THelperFunction.getTitleText(TTextStrings.teams, context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: TeamColumn(
                  teamName: team1Name,
                  teamLogo: team1Logo,
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Text(
                vsText,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: TeamColumn(
                  teamName: team2Name,
                  teamLogo: team2Logo,
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
