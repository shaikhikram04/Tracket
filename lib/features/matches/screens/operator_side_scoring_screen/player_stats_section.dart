import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/features/matches/models/batting_score.dart';
import 'package:tracket/features/matches/models/bowling_score.dart';
import 'package:tracket/features/matches/screens/operator_side_scoring_screen/blur_overlay.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class PlayerStatsSection extends StatelessWidget {
  final BattingScore batsman1;
  final BattingScore batsman2;
  final BowlingScore bowler;
  final bool isBlur;
  final int strikerPosition;

  const PlayerStatsSection({
    super.key,
    required this.batsman1,
    required this.batsman2,
    required this.bowler,
    required this.isBlur,
    required this.strikerPosition,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return ClipRRect(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 2),
                _buildPlayerCard(
                    strikerPosition == batsman1.battingPosition,
                    batsman1.playerName,
                    batsman1.displayScore,
                    'SR: ${batsman1.strikeRate.toStringAsFixed(2)}',
                    batsman1.isOut,
                    isDark),
                const SizedBox(height: 10),
                _buildPlayerCard(
                  strikerPosition == batsman2.battingPosition,
                  batsman2.playerName,
                  batsman2.displayScore,
                  'SR: ${batsman2.strikeRate.toStringAsFixed(2)}',
                  batsman2.isOut,
                  isDark,
                ),
                const SizedBox(height: 15),
                _buildBowlerCard(
                  bowler.playerName,
                  bowler.detailedFigures,
                  'Econ: ${bowler.economy.toStringAsFixed(2)}',
                  isDark,
                ),
              ],
            ),
          ),
          if (isBlur) const BlurOverlay()
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
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isOut
            ? StatusColors.error.withValues(alpha: 0.2)
            : isDark
                ? Colors.black
                : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isStriker
              ? isOut
                  ? StatusColors.error
                  : grassGreen
              : LightThemeColors.tertiaryText.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: isStriker && !isOut
            ? [
                const BoxShadow(
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
          Expanded(
            child: Row(
              children: [
                if (isStriker)
                  Icon(Icons.sports_cricket,
                      color: isDark ? lightGrassGreen : grassGreen, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: isDark
                          ? DarkThemeColors.primaryText
                          : LightThemeColors.primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                score,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isDark ? lightGrassGreen : grassGreen,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                strikeRate,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: isDark
                      ? DarkThemeColors.secondaryText
                      : LightThemeColors.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBowlerCard(
      String name, String figures, String economy, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark
            ? lightGrassGreen.withValues(alpha: 0.2)
            : grassGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: isDark ? lightGrassGreen : grassGreen,
            ),
          ),
          Row(
            children: [
              Text(
                figures,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: isDark ? lightGrassGreen : grassGreen,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                economy,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: isDark
                      ? DarkThemeColors.secondaryText
                      : LightThemeColors.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
