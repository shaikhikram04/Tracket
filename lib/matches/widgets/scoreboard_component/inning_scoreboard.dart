import 'package:flutter/material.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/extras.dart';
import 'package:tracket/matches/models/fall_of_wickets.dart';
import 'package:tracket/matches/widgets/scoreboard_component/batting_scorecard.dart';
import 'package:tracket/matches/widgets/scoreboard_component/bowling_scorecard.dart';

class InningScoreboard extends StatelessWidget {
  const InningScoreboard({
    super.key,
    required this.battingScores,
    required this.extras,
    required this.fallOfWickets,
    required this.overs,
    required this.teamName,
    required this.totalScore,
    required this.wickets,
    required this.bowlingStats,
  });

  final String teamName;
  final List<BattingScore> battingScores;
  final List<BowlingScore> bowlingStats;
  final Extras extras;
  final int totalScore;
  final int wickets;
  final String overs;
  final List<FallOfWicket> fallOfWickets;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BattingScorecard(
          teamName: teamName,
          battingScores: battingScores,
          extras: extras,
          totalScore: totalScore,
          wickets: wickets,
          overs: overs,
          fallOfWickets: fallOfWickets,
        ),
        BowlingScorecard(bowlerStats: bowlingStats, isDarkMode: false),
      ],
    );
  }
}
