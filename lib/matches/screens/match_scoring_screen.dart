import 'package:flutter/material.dart';
import 'package:tracket/matches/widgets/match_status_card.dart';
import 'package:tracket/matches/widgets/scoreboard_section.dart';
import 'package:tracket/utils/colors.dart';

class MatchScoringScreen extends StatelessWidget {
  const MatchScoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ListView(
        children: const [
          MatchStatusCard(),
          ScoreboardSection(),
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
