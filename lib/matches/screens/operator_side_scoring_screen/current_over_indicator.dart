import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/matches/models/ball_outcome.dart';
import 'package:tracket/utils/colors.dart';

class CurrentOverIndicator extends StatelessWidget {
  final List<BallOutcome?> balls;
  final int remainingBalls;
  final bool isBlur;

  const CurrentOverIndicator(
      {required this.balls,
      required this.isBlur,
      required this.remainingBalls});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            padding: EdgeInsets.all(15),
            width: double.infinity,
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(balls.length, (index) {
                      final ballValue = balls[index];
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ballValue != null
                              ? grassGreen
                              : Colors.grey.shade200,
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
                            ballValue?.displayOutcome ?? '',
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
                ),
              ],
            ),
          ),
          if (isBlur)
            Positioned.fill(
              child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 4, sigmaY: 4, tileMode: TileMode.clamp),
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
}
