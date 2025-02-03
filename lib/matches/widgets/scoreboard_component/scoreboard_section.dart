import 'package:flutter/material.dart';
import 'package:tracket/matches/widgets/scoreboard_component/match_scoreboard.dart';
import 'package:tracket/utils/utils.dart';

class ScoreboardSection extends StatelessWidget {
  const ScoreboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 250, 255, 250),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: getTitleText('Scoreboard', context),
          ),
          const Scoreboard(),
        ],
      ),
    );
  }
}
