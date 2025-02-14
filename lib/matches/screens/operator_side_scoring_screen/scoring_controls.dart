import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/providers/extras_provider.dart';
import 'package:tracket/matches/providers/match_provider.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/player_selection_sheet.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/wicket_reason.dart';
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

  void showNextBatsmanSelection(
      BuildContext context, List<MatchPlayerInfo> availableBatsmen) {
    PlayerSelectionSheet.show(
      context: context,
      type: SelectionType.batsman,
      availablePlayers: availableBatsmen,
      onPlayerSelected: (MatchPlayerInfo selectedPlayer) {
        // Handle the selected batsman
        print('Selected batsman: ${selectedPlayer.playerName}');
      },
    );
  }

  void showNextBowlerSelection(
      BuildContext context, List<MatchPlayerInfo> availableBowlers) {
    PlayerSelectionSheet.show(
      context: context,
      type: SelectionType.bowler,
      availablePlayers: availableBowlers,
      onPlayerSelected: (MatchPlayerInfo selectedPlayer) {
        // Handle the selected bowler
        print('Selected bowler: ${selectedPlayer.playerName}');
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extras = ref.watch(extrasProvider);
    final matchState = ref.watch(matchStateProvider);

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
                            ref.read(matchStateProvider.notifier).addDelivery(
                                  runs: runs,
                                  isFour: false,
                                  isSix: false,
                                  extras: extras,
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
                                  ref
                                      .read(matchStateProvider.notifier)
                                      .addDelivery(
                                        runs: runs,
                                        isFour: index == 1,
                                        isSix: index == 2,
                                        extras: extras,
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
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ['Wide', 'No Ball', 'Leg Bye', 'Bye'].map((extra) {
                    // Determine if this button should appear blurred based on current extras.
                    bool shouldBlur = false;
                    if (isBlur) {
                      switch (extra) {
                        case 'Wide':
                          // If Wide is NOT selected but any other extra is selected,
                          // then disable Wide.
                          shouldBlur = extras.isWide ||
                              (extras.isNoBall ||
                                  extras.isLegBye ||
                                  extras.isBye);
                          break;
                        case 'No Ball':
                          // No Ball is only allowed if Wide is not selected.
                          shouldBlur = extras.isNoBall || extras.isWide;
                          break;
                        case 'Leg Bye':
                          // Leg Bye cannot be combined with Wide or Bye.
                          shouldBlur = extras.isLegBye ||
                              (extras.isWide || extras.isBye);
                          break;
                        case 'Bye':
                          // Bye cannot be combined with Wide or Leg Bye.
                          shouldBlur = extras.isBye ||
                              (extras.isWide || extras.isLegBye);
                          break;
                      }
                    }
                    return ClipRRect(
                      child: Stack(
                        children: [
                          Container(
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
                          ),
                          // If shouldBlur is true, apply a blur overlay to this button.
                          if (shouldBlur)
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
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 17),

                // Wicket Button
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      MyElevatedButton.iconTextElevatedButton(
                        onPressed: () async {
                          final result = await showModalBottomSheet(
                            context: context,
                            useSafeArea: true,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => WicketReason(
                              fielders: matchState!.getBowlingTeamPlayers(),
                              strikers: matchState.currentBatsmen!,
                              extras: extras,
                            ),
                          );
                          if (result != null) {
                            ref.read(matchStateProvider.notifier).addDelivery(
                                  runs: result['runsCompleted'] ?? 0,
                                  isWicket: true,
                                  extras: extras,
                                  isFour: false,
                                  isSix: false,
                                  outBatsman: result['runOutBatsman'],
                                  reasonOfOut: result['reasonOfOut'],
                                );
                          }
                          makeUnBlur();
                          showNextBatsmanSelection(
                              context, matchState!.getBattingTeamPlayers());
                        },
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
                      if (extras.isBye || extras.isLegBye)
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 4, sigmaY: 4, tileMode: TileMode.clamp),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                    ],
                  ),
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
