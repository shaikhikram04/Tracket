import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/utils/colors.dart';

class PlayerStatsSection extends StatelessWidget {
  final BattingScore striker;
  final BattingScore nonStriker;
  final BowlingScore bowler;
  final bool isBlur;
  final int strikerIndex;

  const PlayerStatsSection({
    required this.striker,
    required this.nonStriker,
    required this.bowler,
    required this.isBlur,
    required this.strikerIndex,
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
                  strikerIndex == 0,
                  striker.playerName,
                  '${striker.runs}(${striker.balls})',
                  'SR: ${striker.strikeRate.toStringAsFixed(2)}',
                  striker.isOut,
                ),
                SizedBox(height: 10),
                _buildPlayerCard(
                  strikerIndex == 1,
                  nonStriker.playerName,
                  '${nonStriker.runs}(${nonStriker.balls})',
                  'SR: ${nonStriker.strikeRate.toStringAsFixed(2)}',
                  nonStriker.isOut,
                ),
                SizedBox(height: 15),
                _buildBowlerCard(
                  bowler.playerName,
                  '${bowler.oversDisplay}.-${bowler.wickets}-${bowler.runsGiven}',
                  'Econ: ${bowler.economy.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
          if (isBlur)
            Positioned.fill(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    height: double.infinity,
                  )),
            ),
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
              : LightThemeColors.tertiaryText,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: LightThemeColors.tertiaryText,
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
