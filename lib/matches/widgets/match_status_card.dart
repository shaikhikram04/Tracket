import 'package:flutter/material.dart';
import 'package:tracket/matches/widgets/current_players_info.dart';
import 'package:tracket/matches/widgets/match_header.dart';
import 'package:tracket/matches/widgets/recent_ball_indicator.dart';
import 'package:tracket/matches/widgets/teams_score_section.dart';
import 'package:tracket/utils/colors.dart';

class MatchStatusCard extends StatelessWidget {
  const MatchStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: whiteColor,
        border: Border(
          bottom: BorderSide(color: Colors.black12, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          MatchHeader(),
          SizedBox(height: 16),
          TeamsScoreSection(),
          SizedBox(height: 16),
          RecentBallsIndicator(),
          SizedBox(height: 16),
          CurrentPlayersInfo(),
        ],
      ),
    );
  }
}