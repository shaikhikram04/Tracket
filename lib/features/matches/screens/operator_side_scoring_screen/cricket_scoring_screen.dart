import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/features/matches/providers/additional_match_provider.dart';
import 'package:tracket/features/matches/providers/current_over_runs_provider.dart';
import 'package:tracket/features/matches/providers/innings_provider.dart';
import 'package:tracket/features/matches/providers/match_provider.dart';
import 'package:tracket/features/matches/screens/operator_side_scoring_screen/current_over_indicator.dart';
import 'package:tracket/features/matches/screens/operator_side_scoring_screen/player_stats_section.dart';
import 'package:tracket/features/matches/screens/operator_side_scoring_screen/scoreboard_section.dart';
import 'package:tracket/features/matches/screens/operator_side_scoring_screen/scoring_controls.dart';
import 'package:tracket/features/matches/screens/operator_side_scoring_screen/selection_placeholder.dart';
import 'package:tracket/features/matches/services/matches_services.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class CricketScoringScreen extends ConsumerStatefulWidget {
  const CricketScoringScreen({super.key});

  @override
  ConsumerState<CricketScoringScreen> createState() =>
      _CricketScoringScreenState();
}

class _CricketScoringScreenState extends ConsumerState<CricketScoringScreen> {
  bool _isLoading = false;
  bool _isBlur = false;

  @override
  void initState() {
    super.initState();
    loadInningData();
  }

  Future<void> loadInningData() async {
    setState(() {
      _isLoading = true;
    });

    final matchState = ref.read(matchStateProvider);

    try {
      final innings =
          await MatchesServices.getInningsFromMatchId(matchState!.id);
      ref.read(inningsStateProvider.notifier).setInnings(innings);

      final currentOverRuns =
          await MatchesServices.getCurrentOverRuns(matchState.id);

      ref.read(currentOverRunsProvider.notifier).setState(currentOverRuns);

      final isOverCompleted = currentOverRuns.isNotEmpty &&
          currentOverRuns.last.remainingBalls == 0;

      if (isOverCompleted) {
        ref.read(additionalMatchProvider.notifier).setIsOverCompleted(true);
      }

      final isWicketDown = innings.last?.isWicketDownAtNow() ??
          innings.first!.isWicketDownAtNow();

      if (isWicketDown) {
        ref.read(additionalMatchProvider.notifier).setIsWicketDown(true);
      }

      final isInningsCompleted =
          innings.first!.isInningsCompleted && innings.last == null;
      if (isInningsCompleted) {
        ref.read(additionalMatchProvider.notifier).setIsInningsCompleted(true);
      }
    } catch (e) {
      if (mounted) {
        THelperFunction.showSnackBar('Failed to load innings: $e', context);
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onExtraButtonTab() {
    setState(() {
      _isBlur = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final matchState = ref.watch(matchStateProvider);
    final inningState = ref.watch(inningsStateProvider);
    final currentOverState = ref.watch(currentOverRunsProvider);
    final currentBatsman =
        ref.watch(inningsStateProvider.notifier).currentBatsmen;
    final completionState = ref.watch(additionalMatchProvider);

    final isDark = THelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: grassGreen,
        foregroundColor: onPrimary,
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
      body: _isLoading
          ? const CircularLoadingIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Enhanced Score Summary Section
                  ScoreboardSection(
                    currentInning: inningState.last ?? inningState.first!,
                    target: ref.read(inningsStateProvider.notifier).target,
                    team1Name: matchState!.team1.teamName,
                    team2Name: matchState.team2.teamName,
                    isBlur: _isBlur,
                    isTeam1Batting: inningState.last == null,
                    totalOvers: matchState.over,
                  ),

                  // Current Over Indicator with animation
                  CurrentOverIndicator(
                    balls: currentOverState,
                    isBlur: _isBlur,
                    remainingBalls: ref
                        .read(currentOverRunsProvider.notifier)
                        .remainingBalls,
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    bgColor: isDark
                        ? DarkThemeColors.surfaceColor
                        : LightThemeColors.surfaceColor,
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

                  completionState.isOverCompleted ||
                          completionState.isInningsCompleted ||
                          completionState.isMatchCompleted ||
                          completionState.isWicketDown
                      ? const SelectionPlaceholder()
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
