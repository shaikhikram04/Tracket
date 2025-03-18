import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/matches/providers/additional_match_provider.dart';
import 'package:tracket/matches/providers/current_over_runs_provider.dart';
import 'package:tracket/matches/providers/innings_provider.dart';
import 'package:tracket/matches/providers/match_provider.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/player_selection_sheet.dart';
import 'package:tracket/matches/services/matches_services.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class SelectionPlaceholder extends ConsumerWidget {
  const SelectionPlaceholder({super.key});

  void _showNextBowlerSelection(BuildContext context, WidgetRef ref) {
    PlayerSelectionSheet.show(
      context: context,
      type: SelectionType.bowler,
      allPlayers: ref.watch(matchStateProvider)!.getBowlingTeamPlayers(),
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
    PlayerSelectionSheet.show(
      context: context,
      type: SelectionType.batsman,
      allPlayers: ref.read(matchStateProvider)!.getBattingTeamPlayers(),
      onPlayerSelected: (player) {
        ref.read(inningsStateProvider.notifier).setNewBatsmenOnOut(player);
        ref.read(additionalMatchProvider.notifier).setIsWicketDown(false);
      },
      nonAvailablePlayers: nonAvailablePlayersId,
      playingPlayerId: playingPlayer,
    );
  }

  void startNextInning() {}

  void endMatch() {}

  String _getTitle(AdditionalMatchState completionState) {
    if (completionState.isWicketDown) return 'Wicket Down';
    if (completionState.isOverCompleted) return 'Over Completed';
    if (completionState.isInningsCompleted) return 'Inning Completed';
    if (completionState.isMatchCompleted) return 'Match Completed';
    return '';
  }

  String _getSubtitle(AdditionalMatchState completionState) {
    if (completionState.isWicketDown) return 'Tap to select next batsman';
    if (completionState.isOverCompleted) return 'Tap to change bowler';
    if (completionState.isInningsCompleted) return 'Tap to proceed next inning';
    if (completionState.isMatchCompleted) return 'Tab to end Match';
    return '';
  }

  String _getButtonText(AdditionalMatchState completionState) {
    if (completionState.isWicketDown) return 'Select Batsman';
    if (completionState.isOverCompleted) return 'Change Bowler';
    if (completionState.isInningsCompleted) return 'Start 2nd Inning';
    if (completionState.isMatchCompleted) return 'End Match';
    return '';
  }

  void _onTap(
    BuildContext context,
    WidgetRef ref,
    AdditionalMatchState completionState,
  ) {
    if (completionState.isWicketDown) _showNextBatsmanSelection(context, ref);
    if (completionState.isOverCompleted) _showNextBowlerSelection(context, ref);
    if (completionState.isInningsCompleted) startNextInning();
    if (completionState.isMatchCompleted) endMatch();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completionState = ref.read(additionalMatchProvider);

    return Container(
      height: 320,
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
          SizedBox(height: 10),
          Text(
            _getSubtitle(completionState),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
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
