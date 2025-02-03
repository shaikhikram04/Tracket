import 'package:flutter/material.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/widgets/batting_scorecard.dart';
import 'package:tracket/matches/widgets/bowling_scorecard.dart';

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
