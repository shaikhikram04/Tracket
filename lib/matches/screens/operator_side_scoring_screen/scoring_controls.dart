import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/matches/providers/extras_provider.dart';
import 'package:tracket/matches/providers/match_provider.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class ScoringControls extends ConsumerWidget {
  const ScoringControls({
    Key? key,
    required this.onExtra,
    required this.isBlur,
    required this.makeUnBlur,
  }) : super(key: key);

  final VoidCallback onExtra;
  final VoidCallback makeUnBlur;
  final bool isBlur;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extras = ref.watch(extrasProvider);

    return ClipRRect(
      child: Stack(
        children: [
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
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 2,
              children: [
                // Runs Grid
                Row(
                  children: [0, 1, 2, 3].map((runs) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            bool isByes = extras.isBye || extras.isLegBye;
                            ref.read(matchStateProvider.notifier).addDelivery(
                                  runs: runs,
                                  isFour: false,
                                  isSix: false,
                                  isWide: extras.isWide,
                                  isNoBall: extras.isNoBall,
                                  isLegBye: extras.isLegBye,
                                  isBye: extras.isBye,
                                  byeRuns: isByes ? runs : null,
                                );
                            ref.read(extrasProvider.notifier).reset();
                            makeUnBlur();
                          },
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
                      child: ClipRRect(
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              height: 55,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  bool isByes = extras.isBye || extras.isLegBye;
                                  ref
                                      .read(matchStateProvider.notifier)
                                      .addDelivery(
                                        runs: runs,
                                        isFour: index == 1,
                                        isSix: index == 2,
                                        isWide: extras.isWide,
                                        isNoBall: extras.isNoBall,
                                        isLegBye: extras.isLegBye,
                                        isBye: extras.isBye,
                                        byeRuns: isByes ? runs : null,
                                      );
                                  ref.read(extrasProvider.notifier).reset();
                                  makeUnBlur();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      index == 0 ? lightGreen : darkGreenColor,
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
                            if (isBlur &&
                                ((extras.isWide && index == 2) ||
                                    (extras.isLegBye && index == 2) ||
                                    (extras.isBye && index == 2)))
                              Positioned.fill(
                                child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 4,
                                        sigmaY: 4,
                                        tileMode: TileMode.clamp),
                                    child: Container(
                                      color: Colors.transparent,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 17),

                // Extras Wrap
                ClipRRect(
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            ['Wide', 'No Ball', 'Leg Bye', 'Bye'].map((extra) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: ElevatedButton(
                              onPressed: () {
                                onExtra();
                                switch (extra) {
                                  case 'Wide':
                                    ref
                                        .read(extrasProvider.notifier)
                                        .updateExtras((state) =>
                                            state.copyWith(isWide: true));
                                    break;
                                  case 'No Ball':
                                    ref
                                        .read(extrasProvider.notifier)
                                        .updateExtras((state) =>
                                            state.copyWith(isNoBall: true));
                                    break;
                                  case 'Leg Bye':
                                    ref
                                        .read(extrasProvider.notifier)
                                        .updateExtras((state) =>
                                            state.copyWith(isLegBye: true));
                                    break;
                                  case 'Bye':
                                    ref
                                        .read(extrasProvider.notifier)
                                        .updateExtras((state) =>
                                            state.copyWith(isBye: true));
                                    break;
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentGold,
                                elevation: 2,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
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
                            ),
                          );
                        }).toList(),
                      ),
                      if (isBlur)
                        Positioned.fill(
                          child: BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: 4,
                                  sigmaY: 4,
                                  tileMode: TileMode.clamp),
                              child: Container(
                                color: Colors.transparent,
                                width: double.infinity,
                                height: double.infinity,
                              )),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 17),

                // Wicket Button
                MyElevatedButton.iconTextElevatedButton(
                  onPressed: () {},
                  text: 'WICKET',
                  textStyle: MyTextStyle(context).buttonText.copyWith(
                        letterSpacing: 1.2,
                        fontSize: 18,
                      ),
                  icon: Icon(
                    Icons.sports_baseball,
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
          ),
        ],
      ),
    );
  }
}
