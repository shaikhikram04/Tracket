import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/features/matches/models/ball_outcome.dart';
import 'package:tracket/features/matches/screens/operator_side_scoring_screen/blur_overlay.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class CurrentOverIndicator extends StatelessWidget {
  final List<BallOutcome?> balls;
  final int remainingBalls;
  final bool isBlur;
  final bool showShadow;
  final EdgeInsetsGeometry? margin;
  final Color bgColor;

  const CurrentOverIndicator({
    required this.balls,
    required this.isBlur,
    required this.remainingBalls,
    required this.bgColor,
    this.showShadow = true,
    this.margin,
  });

  // Get ball color based on outcome
  Color _getBallColor(BallOutcome? ballOutcome, bool isDark) {
    if (ballOutcome == null) return isDark ? Colors.grey.shade600 : Colors.grey.shade200;

    if (ballOutcome.isWicket) return InteractiveColors.inputError;

    // Extras (wides, no-balls, etc.)
    if (ballOutcome.type == BallType.wide) return Colors.amber;
    if (ballOutcome.type == BallType.noBall) return Colors.orange;
    if (ballOutcome.type == BallType.bye || ballOutcome.type == BallType.legBye) return Colors.teal;
    // return Colors.deepOrange; // Other extras

    // Check if it's a boundary (4 or 6 runs)
    if (ballOutcome.runs == 4 && ballOutcome.isBoundary) return Colors.blue;
    if (ballOutcome.runs == 6) return Colors.purple;

    // Regular runs
    return grassGreen;
  }

  // Get shadow for ball based on outcome
  List<BoxShadow>? _getBallShadow(BallOutcome? ballOutcome) {
    if (ballOutcome == null) return null;

    Color shadowColor;
    if (ballOutcome.isWicket) {
      shadowColor = InteractiveColors.inputError.withValues(alpha: 0.3);
    } else if (ballOutcome.runs == 4) {
      shadowColor = Colors.blue.withValues(alpha: 0.3);
    } else if (ballOutcome.runs == 6) {
      shadowColor = Colors.purple.withValues(alpha: 0.3);
    } else {
      shadowColor = grassGreen.withValues(alpha: 0.3);
    }

    return [
      BoxShadow(
        color: shadowColor,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);
    return ClipRRect(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            margin: margin,
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: showShadow
                  ? [
                      const BoxShadow(
                        color: LightThemeColors.tertiaryText,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              children: [
                Text(
                  'CURRENT OVER',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? lightGrassGreen : grassGreen,
                  ),
                ),
                const SizedBox(height: 10),
                _buildBallsRow(isDark),
              ],
            ),
          ),
          if (isBlur) const BlurOverlay(),
        ],
      ),
    );
  }

  Widget _buildBallsRow(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          balls.length + remainingBalls,
          (index) => _buildBallIndicator(index < balls.length ? balls[index] : null, isDark),
        ),
      ),
    );
  }

  Widget _buildBallIndicator(BallOutcome? ballValue, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getBallColor(ballValue, isDark),
        boxShadow: _getBallShadow(ballValue),
      ),
      child: Center(
        child: Text(
          ballValue?.displayOutcome ?? '',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: LightThemeColors.surfaceColor,
          ),
        ),
      ),
    );
  }
}
