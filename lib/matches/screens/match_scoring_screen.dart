import 'package:flutter/material.dart';
import 'package:tracket/matches/widgets/match_status_card.dart';
import 'package:tracket/matches/widgets/scoreboard_component/scoreboard_section.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class MatchScoringScreen extends StatelessWidget {
  const MatchScoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: whiteColor,
      body: ListView(
        children: [
          MatchStatusCard(),
          ScoreboardSection(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: 'Toss : ',
                    style:
                        MyTextStyle(context).coloredBodyLarge(darkGreenColor),
                  ),
                  TextSpan(text: 'Team 1 won the toss and decided to bat first')
                ])),
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: 'Venue : ',
                    style:
                        MyTextStyle(context).coloredBodyLarge(darkGreenColor),
                  ),
                  TextSpan(text: 'Wafa Complex')
                ])),
              ],
            ),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Match Details'),
      backgroundColor: whiteColor,
      elevation: 0,
      shape: const Border(
        bottom: BorderSide(color: Colors.black12, width: 0.5),
      ),
    );
  }
}
