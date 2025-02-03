import 'package:flutter/material.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/widgets/scoreboard_component/batting_scorecard.dart';
import 'package:tracket/matches/widgets/scoreboard_component/bowling_scorecard.dart';

class InningScoreboard extends StatelessWidget {
  const InningScoreboard({super.key, required this.inning});

  final Inning inning;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BattingScorecard(innings: inning),
        BowlingScorecard(innings: inning),
      ],
    );
  }
}
