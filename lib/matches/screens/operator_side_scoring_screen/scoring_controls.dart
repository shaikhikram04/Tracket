import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/matches/providers/additional_match_provider.dart';
import 'package:tracket/matches/providers/extras_provider.dart';
import 'package:tracket/matches/providers/innings_provider.dart';
import 'package:tracket/matches/providers/match_provider.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/blur_overlay.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/wicket_reason.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
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
    final matchState = ref.watch(matchStateProvider);

    return ClipRRect(
      child: Stack(
        children: [
          if (isBlur) const BlurOverlay(),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 2,
              children: [
                // Runs Grid
                Row(
                  children: [0, 1, 2, 3].map((runs) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(inningsStateProvider.notifier).addDelivery(
                                  runs: runs,
                                  isFour: false,
                                  isSix: false,
                                  extras: extras,
                                );
                            ref.read(extrasProvider.notifier).reset();
                            makeUnBlur();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryLight,
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
                              color: LightThemeColors.surfaceColor,
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
                              margin: const EdgeInsets.all(5),
                              height: 55,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(inningsStateProvider.notifier)
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
                                  backgroundColor: index == 0
                                      ? primaryLight
                                      : primaryVariant,
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
                                    color: LightThemeColors.surfaceColor,
                                  ),
                                ),
                              ),
                            ),
                            if (isBlur &&
                                ((extras.isWide && index == 2) ||
                                    (extras.isLegBye && index == 2) ||
                                    (extras.isBye && index == 2)))
                              const BlurOverlay(),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 17),

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
                            padding: const EdgeInsets.symmetric(vertical: 5),
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
                                backgroundColor: Colors.amberAccent,
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                extra,
                                style: GoogleFonts.poppins(
                                  color: LightThemeColors.primaryText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          // If shouldBlur is true, apply a blur overlay to this button.
                          if (shouldBlur) const BlurOverlay(),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 17),

                // Wicket Button
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      CustomButton.primary(
                        onPressed: () async {
                          final result = await showModalBottomSheet(
                              context: context,
                              useSafeArea: true,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                final wicketkeeperName = ref
                                    .read(inningsStateProvider.notifier)
                                    .currentWicketkeeperName;

                                return WicketReason(
                                  fielders: matchState!.getBowlingTeamPlayers(),
                                  strikers: ref
                                      .read(inningsStateProvider.notifier)
                                      .currentBatsmen!,
                                  extras: extras,
                                  bowler: ref
                                      .read(inningsStateProvider.notifier)
                                      .currentBowler!,
                                  wicketkeeperName: wicketkeeperName,
                                );
                              });
                          if (result != null) {
                            ref.read(inningsStateProvider.notifier).addDelivery(
                                  runs: result['runsCompleted'] ?? 0,
                                  isWicket: true,
                                  extras: extras,
                                  isFour: false,
                                  isSix: false,
                                  outBatsmanPosition: result['runOutBatsman'],
                                  reasonOfOut: result['reasonOfOut'],
                                  dismissalInfo: result['dismissalInfo'],
                                );
                            makeUnBlur();
                            ref
                                .read(additionalMatchProvider.notifier)
                                .setIsWicketDown(true);
                          }
                          makeUnBlur();
                        },
                        text: 'WICKET',
                        textStyle: MyTextStyle(context).buttonText.copyWith(
                              letterSpacing: 1.2,
                              fontSize: 18,
                            ),
                        icon: const Icon(
                          Icons.sports_baseball,
                          color: LightThemeColors.surfaceColor,
                        ),
                        backgroundColor: StatusColors.error,
                        borderRadius: 15,
                        height: 50,
                        width: double.infinity,
                      ),
                      if (extras.isBye || extras.isLegBye) const BlurOverlay(),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
