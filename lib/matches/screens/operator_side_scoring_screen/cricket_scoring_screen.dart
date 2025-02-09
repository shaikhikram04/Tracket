import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/matches/providers/match_provider.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/current_over_indicator.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/player_stats_section.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/scoreboard_section.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/scoring_controls.dart';
import 'package:tracket/utils/colors.dart';

class CricketScoringScreen extends ConsumerStatefulWidget {
  const CricketScoringScreen({Key? key}) : super(key: key);

  @override
  _CricketScoringScreenState createState() => _CricketScoringScreenState();
}

class _CricketScoringScreenState extends ConsumerState<CricketScoringScreen> {
  @override
  Widget build(BuildContext context) {
    final matchState = ref.watch(matchStateProvider);

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: darkGreenColor,
        elevation: 0,
        title: Text(
          'Live Scoring',
          style: GoogleFonts.poppins(
            color: whiteColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.undo, color: accentGold),
            onPressed: () {
              // Implement undo functionality
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Enhanced Score Summary Section
                ScoreboardSection(matchState: matchState!),

                // Current Over Indicator with animation
                CurrentOverIndicator(balls: matchState.currentOverRuns),

                // Player Stats Section with cards
                PlayerStatsSection(
                  striker: matchState.striker!,
                  nonStriker: matchState.nonStriker!,
                  bowler: matchState.currentBowlers!,
                ),

                ScoringControls(),
              ],
            ),
          ),
          // The blur overlay
        ],
      ),
    );
  }
}
