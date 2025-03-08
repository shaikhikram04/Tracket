import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/blur_overlay.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class ScoreboardSection extends StatelessWidget {
  final String team1Name;
  final String team2Name;
  final Inning? currentInning;
  final int? target;
  final bool isBlur;

  const ScoreboardSection({
    required this.team1Name,
    required this.team2Name,
    required this.currentInning,
    required this.target,
    required this.isBlur,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: grassGreen,
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
                  padding: const EdgeInsets.symmetric(horizontal: 10)
                      .copyWith(top: 10),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Text(
                          team1Name,
                          style: MyTextStyle(context).titleLarge.copyWith(
                                color: LightThemeColors.surfaceColor,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      Text(
                        'VS',
                        style: MyTextStyle(context).bodyLarge.copyWith(
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Expanded(
                        child: Text(
                          team2Name,
                          style: MyTextStyle(context).titleLarge.copyWith(
                                color: LightThemeColors.surfaceColor,
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
                            '${currentInning?.runs}/${currentInning?.wickets}',
                            style: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: LightThemeColors.surfaceColor,
                            ),
                          ),
                          Text(
                            '${currentInning?.oversDisplay} Overs',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: LightThemeColors.surfaceColor
                                  .withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                      if (target != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: StatusColors.warning.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'TARGET',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: StatusColors.warning,
                                ),
                              ),
                              Text(
                                '${target}',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: LightThemeColors.surfaceColor,
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
          ),
          if (isBlur) BlurOverlay()
        ],
      ),
    );
  }
}
