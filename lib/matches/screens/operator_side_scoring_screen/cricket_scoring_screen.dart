import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/matches/models/current_player.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/providers/match_provider.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

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

                // Scoring Controls with enhanced design
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

class ScoreboardSection extends StatelessWidget {
  final Match matchState;

  const ScoreboardSection({required this.matchState});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: darkGreenColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Text(
                    'Team A',
                    style: MyTextStyle(context).titleLarge.copyWith(
                          color: whiteColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Text(
                  'VS',
                  style: MyTextStyle(context).bodyLarge.copyWith(
                        color: accentGold.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Expanded(
                  child: Text(
                    'Team B',
                    style: MyTextStyle(context).titleLarge.copyWith(
                          color: whiteColor,
                          fontWeight: FontWeight.w700,
                        ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${matchState.inning1?.runs}/${matchState.inning1?.wickets}',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                      ),
                    ),
                    Text(
                      '${matchState.inning1?.oversDisplay} Overs',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: whiteColor.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                if (matchState.inning1?.runs != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: accentGold.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'TARGET',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: accentGold,
                          ),
                        ),
                        Text(
                          '${matchState.inning1?.runs}',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CurrentOverIndicator extends StatelessWidget {
  final List balls;

  const CurrentOverIndicator({required this.balls});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: lightGrey,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'CURRENT OVER',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkGreenColor,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              final ballValue = index < balls.length ? balls[index] : null;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ballValue != null ? grassGreen : Colors.grey.shade200,
                  boxShadow: ballValue != null
                      ? [
                          BoxShadow(
                            color: grassGreen.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    ballValue?.toString() ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class PlayerStatsSection extends StatelessWidget {
  final StrikerData striker;
  final StrikerData nonStriker;
  final CurrentBowlerData bowler;

  const PlayerStatsSection({
    required this.striker,
    required this.nonStriker,
    required this.bowler,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildPlayerCard(
            true,
            striker.playerName,
            '${striker.runs}(${striker.balls})',
            'SR: ${striker.strikeRate}',
          ),
          SizedBox(height: 10),
          _buildPlayerCard(
            false,
            nonStriker.playerName,
            '${nonStriker.runs}(${nonStriker.balls})',
            'SR: ${nonStriker.strikeRate}',
          ),
          SizedBox(height: 15),
          _buildBowlerCard(
            bowler.playerName,
            '${bowler.oversDisplay}.-${bowler.wickets}-${bowler.runsGiven}',
            'Econ: ${bowler.economy}',
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(
      bool isStriker, String name, String score, String strikeRate) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isStriker ? grassGreen : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: lightGrey,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isStriker)
                Icon(Icons.sports_cricket, color: grassGreen, size: 20),
              SizedBox(width: 8),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: blackColor,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                score,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: darkGreenColor,
                ),
              ),
              SizedBox(width: 10),
              Text(
                strikeRate,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBowlerCard(String name, String figures, String economy) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: grassGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: darkGreenColor,
            ),
          ),
          Row(
            children: [
              Text(
                figures,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: darkGreenColor,
                ),
              ),
              SizedBox(width: 10),
              Text(
                economy,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScoringControls extends ConsumerWidget {
  const ScoringControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Runs Grid
          Row(
            children: [0, 1, 2, 3].map((runs) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightGreen,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '$runs',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Row(
            children: List.generate(3, (index) {
              int runs = index < 2 ? 4 : 6;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: index == 0 ? lightGreen : darkGreenColor,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '$runs',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 25),

          // Extras Wrap
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ['Wide', 'No Ball', 'Leg Bye', 'Bye'].map((extra) {
              return ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGold,
                  elevation: 2,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  extra,
                  style: GoogleFonts.poppins(
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 25),

          // Wicket Button
          MyElevatedButton.iconTextElevatedButton(
            onPressed: () {},
            text: 'WICKET',
            textStyle: MyTextStyle(context).buttonText.copyWith(
                  letterSpacing: 1.2,
                  fontSize: 18,
                ),
            icon: Icon(
              Icons.sports_cricket,
              color: whiteColor,
            ),
            backgroundColor: Colors.red.shade600,
            borderRadius: 15,
            height: 50,
            width: double.infinity,
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
