import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/blur_overlay.dart';
import 'package:tracket/utils/colors.dart';

class PlayerStatsSection extends StatelessWidget {
  final BattingScore batsman1;
  final BattingScore batsman2;
  final BowlingScore bowler;
  final bool isBlur;
  final int strikerPosition;

  const PlayerStatsSection({
    required this.batsman1,
    required this.batsman2,
    required this.bowler,
    required this.isBlur,
    required this.strikerPosition,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 2),
                _buildPlayerCard(
                  strikerPosition == batsman1.battingPosition,
                  batsman1.playerName,
                  batsman1.displayScore,
                  'SR: ${batsman1.strikeRate.toStringAsFixed(2)}',
                  batsman1.isOut,
                ),
                SizedBox(height: 10),
                _buildPlayerCard(
                  strikerPosition == batsman2.battingPosition,
                  batsman2.playerName,
                  batsman2.displayScore,
                  'SR: ${batsman2.strikeRate.toStringAsFixed(2)}',
                  batsman2.isOut,
                ),
                SizedBox(height: 15),
                _buildBowlerCard(
                  bowler.playerName,
                  '${bowler.oversDisplay}-${bowler.wickets}-${bowler.runsGiven}',
                  'Econ: ${bowler.economy.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
          if (isBlur) BlurOverlay()
        ],
      ),
    );
  }

  Widget _buildPlayerCard(
    bool isStriker,
    String name,
    String score,
    String strikeRate,
    bool isOut,
  ) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isOut ? StatusColors.error.withValues(alpha: 0.2) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isStriker
              ? isOut
                  ? StatusColors.error
                  : grassGreen
              : LightThemeColors.tertiaryText.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: isStriker
            ? [
                BoxShadow(
                  color: LightThemeColors.tertiaryText,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
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
                  color: LightThemeColors.primaryText,
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
                  color: grassGreen,
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
              color: grassGreen,
            ),
          ),
          Row(
            children: [
              Text(
                figures,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: grassGreen,
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
