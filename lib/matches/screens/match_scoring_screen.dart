import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/widgets/match_score_component/match_status_card.dart';
import 'package:tracket/matches/widgets/match_score_component/toss_venue_section.dart';
import 'package:tracket/matches/widgets/scoreboard_component/scoreboard_section.dart';
import 'package:tracket/utils/colors.dart';

class MatchScoringScreen extends StatelessWidget {
  const MatchScoringScreen({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: whiteColor,
      body: ListView(
        children: [
          MatchStatusCard(match: match),
          ScoreboardSection(
            inning1: match.inning1,
            inning2: match.inning2,
            team1Players: match.team1Players,
            team2Players: match.team2Players,
            team1: match.team1,
            team2: match.team2,
          ),
          TossVenueSection(match: match),
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
