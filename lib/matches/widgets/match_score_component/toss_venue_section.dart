import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class TossVenueSection extends StatelessWidget {
  const TossVenueSection({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    String tossWinner = '';
    if (match.isTeam1WonToss != null) {
      tossWinner =
          match.isTeam1WonToss! ? match.team1.teamName : match.team2.teamName;
    }

    String decision = '';
    if (match.tossDecision != null) {
      decision = match.tossDecision! == TossDecision.batting ? 'bat' : 'bowl';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (match.isTeam1WonToss != null)
            Text.rich(TextSpan(children: [
              TextSpan(
                text: 'Toss : ',
                style: MyTextStyle(context)
                    .bodyLarge
                    .copyWith(color: darkGreenColor),
              ),
              TextSpan(
                  text:
                      '$tossWinner won the toss and decided to $decision first')
            ])),
          Text.rich(TextSpan(children: [
            TextSpan(
              text: 'Venue : ',
              style: MyTextStyle(context)
                  .bodyLarge
                  .copyWith(color: darkGreenColor),
            ),
            TextSpan(text: match.venue)
          ])),
        ],
      ),
    );
  }
}
