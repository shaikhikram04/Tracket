import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class ScoreboardSection extends StatelessWidget {
  final Match matchState;

  const ScoreboardSection({required this.matchState});

  @override
  Widget build(BuildContext context) {
    final Inning currentInning = matchState.inningNumber == 1
        ? matchState.inning1!
        : matchState.inning2!;

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
                      '${currentInning.runs}/${currentInning.wickets}',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                      ),
                    ),
                    Text(
                      '${currentInning.oversDisplay} Overs',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: whiteColor.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                if (matchState.inningNumber == 2)
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
                          '${matchState.target!}',
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
