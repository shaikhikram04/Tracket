import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/features/matches/models/match.dart';
import 'package:tracket/features/matches/providers/additional_match_provider.dart';
import 'package:tracket/features/matches/providers/current_over_runs_provider.dart';
import 'package:tracket/features/matches/providers/innings_provider.dart';
import 'package:tracket/features/matches/providers/match_provider.dart';
import 'package:tracket/features/matches/screens/match_players_selection_screen.dart';
import 'package:tracket/features/matches/screens/operator_side_scoring_screen/loser_display.dart';
import 'package:tracket/features/matches/screens/operator_side_scoring_screen/player_selection_sheet.dart';
import 'package:tracket/features/matches/screens/operator_side_scoring_screen/winner_display.dart';
import 'package:tracket/features/matches/services/matches_services.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';

class SelectionPlaceholder extends ConsumerStatefulWidget {
  const SelectionPlaceholder({super.key});

  @override
  ConsumerState<SelectionPlaceholder> createState() =>
      _SelectionPlaceholderState();
}

class _SelectionPlaceholderState extends ConsumerState<SelectionPlaceholder> {
  @override
  void initState() {
    super.initState();
    final matchCondition = ref.read(additionalMatchProvider);

    if (matchCondition.isMatchCompleted) {
      _endMatch(context, ref);
    }
  }

  void _showNextBowlerSelection(BuildContext context, WidgetRef ref) {
    final matchState = ref.read(matchStateProvider)!;
    final playersList = matchState.getBowlingTeamPlayers();

    PlayerSelectionSheet.show(
      context: context,
      type: SelectionType.bowler,
      allPlayers: playersList,
      onPlayerSelected: (player) async {
        // Handle the selected bowler
        ref.read(inningsStateProvider.notifier).changeBowler(player.playerId);
        ref.read(additionalMatchProvider.notifier).setIsOverCompleted(false);
        ref.read(currentOverRunsProvider.notifier).clear();

        await MatchesServices.deleteBallsCollection(
            ref.read(matchStateProvider)!.id);
      },
      nonAvailablePlayers: [],
      playingPlayerId: ref
          .watch(inningsStateProvider.notifier)
          .currentInnings!
          .currentBowlerId,
    );
  }

  void _showNextBatsmanSelection(BuildContext context, WidgetRef ref) {
    final battingStats =
        ref.read(inningsStateProvider.notifier).currentInnings!.battingStats;

    final nonAvailablePlayersId = <String>[];
    String playingPlayer = '';
    for (final batsman in battingStats) {
      if (batsman.isOut)
        nonAvailablePlayersId.add(batsman.uuid);
      else
        playingPlayer = batsman.uuid;
    }

    final playersList = ref.read(matchStateProvider)!.getBattingTeamPlayers();
    PlayerSelectionSheet.show(
      context: context,
      type: SelectionType.batsman,
      allPlayers: playersList,
      onPlayerSelected: (player) {
        ref.read(inningsStateProvider.notifier).setNewBatsmenOnOut(player);
        ref.read(additionalMatchProvider.notifier).setIsWicketDown(false);
      },
      nonAvailablePlayers: nonAvailablePlayersId,
      playingPlayerId: playingPlayer,
    );
  }

  void _startNextInning(BuildContext context, WidgetRef ref) {
    // Handle the next inning
    pushScreen(
        context, const MatchPlayersSelectionScreen(isInning1ToStart: false));
  }

  Future<void> _endMatch(BuildContext context, WidgetRef ref) async {
    // Handle the match completion
    final matchState = ref.read(matchStateProvider)!;
    final team1Players = matchState.team1Players;
    final team2Players = matchState.team2Players;

    final innings = ref.read(inningsStateProvider);

    final inning1BattingStats = innings.first!.battingStats;
    final inning1BowlingStats = innings.first!.bowlingStats;

    final inning2BattingStats = innings.last!.battingStats;
    final inning2BowlingStats = innings.last!.bowlingStats;

    final team1Id = matchState.team1.teamId;
    final team2Id = matchState.team2.teamId;
    final matchFormat = matchState.matchFormat;
    final isTeam1Won = matchState.winningTeamId == matchState.team1.teamId;

    //* showing circular progress indicator
    await showLoadingDialog(
      context,
      message: 'Finishing match...',
    );

    await MatchesServices.updateTeamStatsAfterMatchCompletion(
      team1Id: team1Id,
      team2Id: team2Id,
      matchFormat: matchFormat,
      isTeam1Won: isTeam1Won,
    );

    await MatchesServices.addMatchStatsToCorrespondingPlayers(
      matchFormat: matchFormat,
      team1Players: team1Players,
      team2Players: team2Players,
      inning1BattingStats: inning1BattingStats,
      inning1BowlingStats: inning1BowlingStats,
      inning2BattingStats: inning2BattingStats,
      inning2BowlingStats: inning2BowlingStats,
    );

    Navigator.of(context).pop(); // Close the loading dialog
  }

  String _getTitle(AdditionalMatchState completionState) {
    if (completionState.isInningsCompleted)
      return 'Inning Completed';
    else if (completionState.isWicketDown)
      return 'Wicket Down';
    else if (completionState.isOverCompleted) return 'Over Completed';
    return '';
  }

  String _getSubtitle(AdditionalMatchState completionState) {
    if (completionState.isInningsCompleted)
      return 'Tap to proceed next inning';
    else if (completionState.isWicketDown)
      return 'Tap to select next batsman';
    else if (completionState.isOverCompleted) return 'Tap to change bowler';
    return '';
  }

  String _getButtonText(AdditionalMatchState completionState) {
    if (completionState.isInningsCompleted)
      return 'Start 2nd Inning';
    else if (completionState.isWicketDown)
      return 'Select Batsman';
    else if (completionState.isOverCompleted) return 'Change Bowler';
    return '';
  }

  void _onTap(
    BuildContext context,
    WidgetRef ref,
    AdditionalMatchState completionState,
  ) {
    if (completionState.isInningsCompleted)
      _startNextInning(context, ref);
    else if (completionState.isWicketDown)
      _showNextBatsmanSelection(context, ref);
    else if (completionState.isOverCompleted)
      _showNextBowlerSelection(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    final completionState = ref.watch(additionalMatchProvider);

    if (completionState.isMatchCompleted) {
      final matchState = ref.read(matchStateProvider)!;

      final operatorId = matchState.startBy;
      final winningTeamPlayers = matchState.winningTeamPlayers;
      final isOperatorTeamWin =
          winningTeamPlayers.any((player) => player.playerId == operatorId);

      final marginSuffix =
          matchState.winningMethod == WinningMethod.byRuns ? 'runs' : 'wickets';
      final String marginText = '${matchState.winningMargin} $marginSuffix';

      return isOperatorTeamWin
          ? WinningStatusWidget(
              winningTeam: matchState.winningTeamName,
              winningMargin: 'Won by $marginText',
              animationPath: 'assets/animations/trophy.json')
          : LossStatusWidget(
              losingTeam: matchState.losingTeamName,
              losingMargin: 'Lost by $marginText',
              animationPath: 'assets/animations/sad_face.json',
            );
    } else
      return Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getTitle(completionState),
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _getSubtitle(completionState),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton.primary(
              onPressed: () => _onTap(context, ref, completionState),
              text: _getButtonText(completionState),
              textStyle: MyTextStyle(context).buttonText,
              borderRadius: 15,
              height: 50,
              width: 300,
            ),
          ],
        ),
      );
  }
}
