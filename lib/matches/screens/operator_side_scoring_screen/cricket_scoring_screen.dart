import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/matches/providers/additional_match_provider.dart';
import 'package:tracket/matches/providers/current_over_runs_provider.dart';
import 'package:tracket/matches/providers/innings_provider.dart';
import 'package:tracket/matches/providers/match_provider.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/current_over_indicator.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/player_selection_sheet.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/player_stats_section.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/scoreboard_section.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/scoring_controls.dart';
import 'package:tracket/matches/services/matches_services.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';

class CricketScoringScreen extends ConsumerStatefulWidget {
  const CricketScoringScreen({Key? key}) : super(key: key);

  @override
  _CricketScoringScreenState createState() => _CricketScoringScreenState();
}

class _CricketScoringScreenState extends ConsumerState<CricketScoringScreen> {
  late ValueNotifier<bool> isLoading;
  bool _isBlur = false;

  @override
  void initState() {
    super.initState();
    isLoading = ValueNotifier(false);
    loadInningData();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
  }

  Future<void> loadInningData() async {
    setState(() {
      isLoading.value = true;
    });

    final matchState = ref.read(matchStateProvider);

    try {
      final innings =
          await MatchesServices.getInningsFromMatchId(matchState!.id);
      ref.read(inningsStateProvider.notifier).setInnings(innings);

      final currentOverRuns =
          await MatchesServices.getCurrentOverRuns(matchState.id);

      ref.read(currentOverRunsProvider.notifier).setState(currentOverRuns);
    } catch (e) {
      showSnackBar('Failed to sent innings : $e', context);
    }

    setState(() {
      isLoading.value = false;
    });
  }

  void _onExtraButtonTab() {
    setState(() {
      _isBlur = true;
    });
  }

  void _showNextBowlerSelection(BuildContext context, WidgetRef ref) {
    PlayerSelectionSheet.show(
      context: context,
      type: SelectionType.bowler,
      allPlayers: ref.watch(matchStateProvider)!.getBowlingTeamPlayers(),
      onPlayerSelected: (player) {
        // Handle the selected bowler
        ref.read(inningsStateProvider.notifier).changeBowler(player.playerId);
        ref.read(additionalMatchProvider.notifier).setIsOverCompleted(false);
      },
      nonAvailablePlayers: [],
      playingPlayerId: ref
          .watch(inningsStateProvider.notifier)
          .currentInnings!
          .currentBowlerId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final matchState = ref.watch(matchStateProvider);
    final inningState = ref.watch(inningsStateProvider);
    final currentOverState = ref.watch(currentOverRunsProvider);
    final currentBatsman =
        ref.watch(inningsStateProvider.notifier).currentBatsmen;
    final isOverCompleted = ref.watch(
        additionalMatchProvider.select((state) => state.isOverCompleted));

    return Scaffold(
      backgroundColor: LightThemeColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: grassGreen,
        foregroundColor: onPrimary,
        elevation: 0,
        title: Text(
          'Live Scoring',
          style: GoogleFonts.poppins(
            color: LightThemeColors.surfaceColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.undo, color: LightThemeColors.primaryText),
        //     onPressed: () {
        //       // Implement undo functionality
        //     },
        //   ),
        // ],
      ),
      body: isLoading.value == true
          ? getCircleLoadingIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Enhanced Score Summary Section
                  ScoreboardSection(
                    currentInning: inningState.last ?? inningState.first!,
                    target: inningState.last?.runs,
                    team1Name: matchState!.team1.teamName,
                    team2Name: matchState.team2.teamName,
                    isBlur: _isBlur,
                  ),

                  // Current Over Indicator with animation
                  CurrentOverIndicator(
                    balls: currentOverState,
                    isBlur: _isBlur,
                    remainingBalls: ref
                        .read(currentOverRunsProvider.notifier)
                        .remainingBalls,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    bgColor: LightThemeColors.surfaceColor,
                  ),

                  // Player Stats Section with cards
                  PlayerStatsSection(
                    batsman1: currentBatsman![0],
                    batsman2: currentBatsman[1],
                    bowler:
                        ref.watch(inningsStateProvider.notifier).currentBowler!,
                    strikerPosition: inningState.last?.strikerPosition ??
                        inningState.first!.strikerPosition,
                    isBlur: _isBlur,
                  ),

                  isOverCompleted
                      ? Container(
                          height: 326,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Over Completed',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Tap to change bowler',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 20),
                              CustomButton.primary(
                                onPressed: () =>
                                    _showNextBowlerSelection(context, ref),
                                text: 'Change Bowler',
                                textStyle: MyTextStyle(context).buttonText,
                                icon: Icon(
                                  Icons.sports_baseball,
                                  color: LightThemeColors.surfaceColor,
                                ),
                                borderRadius: 15,
                                height: 50,
                                width: 300,
                              ),
                            ],
                          ),
                        )
                      : ScoringControls(
                          onExtra: _onExtraButtonTab,
                          isBlur: _isBlur,
                          makeUnBlur: () {
                            setState(() {
                              _isBlur = false;
                            });
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
