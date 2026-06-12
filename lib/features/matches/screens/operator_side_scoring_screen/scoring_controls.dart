import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/features/matches/providers/additional_match_provider.dart';
import 'package:tracket/features/matches/providers/extras_provider.dart';
import 'package:tracket/features/matches/providers/innings_provider.dart';
import 'package:tracket/features/matches/providers/match_provider.dart';
import 'package:tracket/features/matches/screens/operator_side_scoring_screen/blur_overlay.dart';
import 'package:tracket/features/matches/screens/operator_side_scoring_screen/wicket_reason.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';

class ScoringControls extends ConsumerWidget {
  const ScoringControls({
    super.key,
    required this.onExtra,
    required this.isBlur,
    required this.makeUnBlur,
  });

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
                        height: 48,
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
                              fontSize: 18,
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
                              height: 48,
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
                                    fontSize: 18,
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
                  runSpacing: 2,
                  children: _extraButtons(extras).map((btn) {
                    final shouldBlur = isBlur && btn.isDisabled;
                    return ClipRRect(
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ElevatedButton(
                              onPressed: () {
                                onExtra();
                                ref
                                    .read(extrasProvider.notifier)
                                    .updateExtras(btn.apply);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amberAccent,
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                btn.label,
                                style: GoogleFonts.poppins(
                                  color: DarkThemeColors.surfaceColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
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
                        textStyle:
                            Theme.of(context).textTheme.titleLarge!.copyWith(
                                  letterSpacing: 1.2,
                                ),
                        icon: const Icon(
                          Icons.sports_baseball,
                          color: LightThemeColors.surfaceColor,
                        ),
                        backgroundColor: StatusColors.error,
                        borderRadius: 15,
                        height: 45,
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

class _ExtraButton {
  final String label;
  final bool isDisabled;
  final ExtrasState Function(ExtrasState) apply;

  const _ExtraButton({
    required this.label,
    required this.isDisabled,
    required this.apply,
  });
}

List<_ExtraButton> _extraButtons(ExtrasState e) => [
      _ExtraButton(
        label: 'Wide',
        isDisabled: e.isWide || e.isNoBall || e.isLegBye || e.isBye,
        apply: (s) => s.copyWith(isWide: true),
      ),
      _ExtraButton(
        label: 'No Ball',
        isDisabled: e.isNoBall || e.isWide,
        apply: (s) => s.copyWith(isNoBall: true),
      ),
      _ExtraButton(
        label: 'Leg Bye',
        isDisabled: e.isLegBye || e.isWide || e.isBye,
        apply: (s) => s.copyWith(isLegBye: true),
      ),
      _ExtraButton(
        label: 'Bye',
        isDisabled: e.isBye || e.isWide || e.isLegBye,
        apply: (s) => s.copyWith(isBye: true),
      ),
    ];
