import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/blur_overlay.dart';
import 'package:tracket/utils/colors.dart';

class ScoreboardSection extends StatelessWidget {
  final String team1Name;
  final String team2Name;
  final Inning? currentInning;
  final int? target;
  final bool isBlur;
  final int totalOvers;
  final bool isTeam1Batting;

  const ScoreboardSection({
    Key? key,
    required this.team1Name,
    required this.team2Name,
    required this.currentInning,
    required this.target,
    required this.isBlur,
    required this.totalOvers,
    required this.isTeam1Batting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            grassGreen.withValues(alpha: 0.9),
            grassGreen,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background patterns
          const Positioned(
            right: -20,
            top: -20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.sports_cricket,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),

          // Main content
          Column(
            children: [
              // Teams header
              Container(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    spacing: 8,
                    children: [
                      // Team 1
                      _buildTeamDisplay(
                        context,
                        team1Name,
                        isTeam1Batting,
                        Alignment.centerLeft,
                      ),

                      // VS badge
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'VS',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ),

                      // Team 2
                      _buildTeamDisplay(
                        context,
                        team2Name,
                        !isTeam1Batting,
                        Alignment.centerRight,
                      ),
                    ],
                  ),
                ),
              ),

              // Scores and info
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Score and overs
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Current batting team label
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isTeam1Batting ? team1Name : team2Name,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: LightThemeColors.surfaceColor
                                    .withValues(alpha: 0.9),
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          // Score
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${currentInning?.runs ?? 0}',
                                style: GoogleFonts.poppins(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: LightThemeColors.surfaceColor,
                                ),
                              ),
                              Text(
                                '/${currentInning?.wickets ?? 0}',
                                style: GoogleFonts.poppins(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: LightThemeColors.surfaceColor
                                      .withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),

                          // Overs pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.sports_baseball_outlined,
                                  size: 16,
                                  color: LightThemeColors.surfaceColor
                                      .withValues(alpha: 0.9),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${currentInning?.oversDisplay ?? '0.0'}/${totalOvers}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: LightThemeColors.surfaceColor
                                        .withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Target display
                    if (target != null)
                      Expanded(
                        flex: 2,
                        child: _buildTargetDisplay(context),
                      ),
                  ],
                ),
              ),

              // Match info strip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Required runs
                    if (target != null) _buildRequiredRunsDisplay(context),

                    // Current run rate
                    _buildRunRateDisplay(context),
                  ],
                ),
              ),
            ],
          ),

          // Blur overlay if needed
          if (isBlur) const BlurOverlay(),
        ],
      ),
    );
  }

  Widget _buildTeamDisplay(BuildContext context, String teamName,
      bool isBatting, Alignment alignment) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isBatting
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.transparent,
          border: isBatting
              ? Border.all(
                  color: Colors.amberAccent.withValues(alpha: 0.6), width: 1)
              : null,
        ),
        child: Row(
          mainAxisAlignment: alignment == Alignment.centerLeft
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            if (alignment == Alignment.centerLeft && isBatting)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.sports_cricket,
                  color: Colors.amberAccent,
                  size: 16,
                ),
              ),
            Expanded(
              child: Text(
                teamName,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: isBatting ? FontWeight.w700 : FontWeight.w500,
                  color: LightThemeColors.surfaceColor,
                ),
                textAlign: alignment == Alignment.centerLeft
                    ? TextAlign.left
                    : TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (alignment == Alignment.centerRight && isBatting)
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Icon(
                  Icons.sports_cricket,
                  color: Colors.amberAccent,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetDisplay(BuildContext context) {
    final runsNeeded = target! - (currentInning?.runs ?? 0);

    return Container(
      margin: const EdgeInsets.only(left: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            StatusColors.warning.withValues(alpha: 0.3),
            StatusColors.warning.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: StatusColors.warning.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Target label
          Text(
            'TARGET',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: StatusColors.warning,
            ),
          ),

          const SizedBox(height: 2),

          // Target value
          Text(
            '$target',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: LightThemeColors.surfaceColor,
            ),
          ),

          // Divider
          Divider(
            color: Colors.white.withValues(alpha: 0.2),
            height: 12,
          ),

          // Runs needed
          Text(
            'Need $runsNeeded',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: LightThemeColors.surfaceColor.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequiredRunsDisplay(BuildContext context) {
    final runsNeeded = target! - (currentInning?.runs ?? 0);
    final ballsRemaining = (totalOvers * 6) - currentInning!.balls;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Need $runsNeeded off $ballsRemaining',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRunRateDisplay(BuildContext context) {
    // Calculate current run rate
    double currentRunRate = currentInning!.runRate;

    // Calculate required run rate if target exists
    double requiredRunRate = 0;
    if (target != null) {
      final runsNeeded = target! - (currentInning?.runs ?? 0);
      final ballRemaining = totalOvers * 6 - currentInning!.balls;
      if (ballRemaining > 0) {
        requiredRunRate = (runsNeeded / ballRemaining) * 6;
      }
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Text(
                'CRR: ${currentRunRate.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              if (target != null)
                Text(
                  ' | RRR: ${requiredRunRate.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: requiredRunRate > currentRunRate + 2
                        ? Colors.redAccent
                        : requiredRunRate < currentRunRate
                            ? Colors.greenAccent
                            : Colors.amber,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
