import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/matches/models/ball_outcome.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/current_player.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';

class MatchStateNotifier extends StateNotifier<Match?> {
  MatchStateNotifier(super.state);

  // Current innings getter
  Inning? get currentInnings {
    if (state == null) return null;
    return state!.inning2 ?? state!.inning1;
  }

  // Match initialization methods
  Future<void> createMatch({
    required MatchTeamInfo team1,
    required MatchTeamInfo team2,
    required List<MatchPlayerInfo> team1Players,
    required List<MatchPlayerInfo> team2Players,
    required MatchFormat matchFormat,
    required MatchType matchType,
    required String venue,
    required DateTime schedule,
    required int noOfPlayer,
  }) async {
    state = Match(
      team1: team1,
      team2: team2,
      team1Players: team1Players,
      team2Players: team2Players,
      matchFormat: matchFormat,
      matchType: matchType,
      venue: venue,
      schedule: schedule,
      noOfPlayer: noOfPlayer,
      currentBatsmen: [],
      strikerIndex: 0,
      currentBowlers: null,
    );
  }

  // Toss management
  void setTossResult(bool isTeam1Won, TossDecision decision) {
    if (state == null) return;

    state = state!.copyWith(
      isTeam1WonToss: isTeam1Won,
      tossDecision: decision,
    );
  }

  // Innings management
  void startFirstInnings() {
    if (state == null) return;

    state = state!.initializeFirstInnings();
  }

  void startSecondInnings() {
    if (state == null) return;

    state = state!.initializeSecondInnings();
  }

  void updateStrikers({
    required int strikerIndex,
    List<StrikerData>? batsmen,
  }) {
    if (state == null) return;

    state = state!.copyWith(
      strikerIndex: strikerIndex,
      currentBatsmen: batsmen ?? state!.currentBatsmen,
    );
  }

  void changeBowler(CurrentBowlerData? bowler) {
    if (state == null) return;

    state = state!.copyWith(currentBowler: bowler);
  }

  // Batting management
  void updateBattingScore({
    required String batsmanId,
    required int runs,
    required bool isFour,
    required bool isSix,
    required int ballsFaced,
  }) {
    if (currentInnings == null) return;

    final battingStats = currentInnings!.battingStats;
    final batsmanIndex =
        battingStats.indexWhere((stats) => stats.uuid == batsmanId);

    if (batsmanIndex == -1) return;

    final updatedBattingStats = List<BattingScore>.from(battingStats);
    updatedBattingStats[batsmanIndex] = battingStats[batsmanIndex].copyWith(
      runs: (battingStats[batsmanIndex].runs ?? 0) + runs,
      ballsFaced: (battingStats[batsmanIndex].ballsFaced ?? 0) + ballsFaced,
      fours: isFour
          ? (battingStats[batsmanIndex].fours ?? 0) + 1
          : battingStats[batsmanIndex].fours,
      sixes: isSix
          ? (battingStats[batsmanIndex].sixes ?? 0) + 1
          : battingStats[batsmanIndex].sixes,
    );

    _updateInnings(battingStats: updatedBattingStats);
  }

  // Bowling management
  void updateBowlingScore({
    required String bowlerId,
    required int runs,
    required bool isWide,
    required bool isNoBall,
    required bool isWicket,
    required bool isDot,
  }) {
    if (currentInnings == null) return;

    final bowlingStats = currentInnings!.bowlingStats;
    final bowlerIndex =
        bowlingStats.indexWhere((stats) => stats.uuid == bowlerId);

    if (bowlerIndex == -1) return;

    final updatedBowlingStats = List<BowlingScore>.from(bowlingStats);
    updatedBowlingStats[bowlerIndex] = bowlingStats[bowlerIndex].addBall(
      runs: runs,
      isWide: isWide,
      isNoBall: isNoBall,
      isWicket: isWicket,
    );

    // Check for maiden over
    if (_isCompletedOver(updatedBowlingStats[bowlerIndex].balls) &&
        _isLastOverMaiden(bowlerId)) {
      updatedBowlingStats[bowlerIndex] =
          updatedBowlingStats[bowlerIndex].addMaidenOver();
    }

    _updateInnings(bowlingStats: updatedBowlingStats);
  }

  // Ball-by-ball scoring
  void addDelivery({
    required int runs,
    required bool isFour,
    required bool isSix,
    bool isWide = false,
    bool isNoBall = false,
    bool isBye = false,
    bool isLegBye = false,
    int? byeRuns,
  }) {
    if (currentInnings == null) return;

    final updatedInnings = currentInnings!.addDelivery(
      runs: runs,
      isFour: isFour,
      isSix: isSix,
      isWide: isWide,
      isNoBall: isNoBall,
      isBye: isBye,
      isLegBye: isLegBye,
      byeRuns: byeRuns,
    );

    final ballOutcome = BallOutcome(
      type: isWide
          ? BallType.wide
          : isNoBall
              ? BallType.noBall
              : isBye
                  ? BallType.bye
                  : isLegBye
                      ? BallType.legBye
                      : BallType.valid,
      runs: runs,
    );

    _updateCurrentInnings(updatedInnings);
    _updateCurrentOverRuns(ballOutcome);
    final int strikerIndex =
        runs % 2 == 0 ? state!.strikerIndex : (state!.strikerIndex + 1) % 2;
    updateStrikers(strikerIndex: strikerIndex);
  }

  // Helper methods
  void _updateInnings({
    List<BattingScore>? battingStats,
    List<BowlingScore>? bowlingStats,
    int? wickets,
  }) {
    if (currentInnings == null) return;

    final updatedInnings = currentInnings!.copyWith(
      battingStats: battingStats,
      bowlingStats: bowlingStats,
      wickets: wickets,
    );

    _updateCurrentInnings(updatedInnings);
  }

  void _updateCurrentInnings(Inning updatedInnings) {
    if (state == null) return;

    if (state!.inning2 != null) {
      state = state!.copyWith(inning2: updatedInnings);
    } else {
      state = state!.copyWith(inning1: updatedInnings);
    }
  }

  void _updateCurrentOverRuns(BallOutcome updatedOverRuns) {
    if (state == null) return;

    state = state!.copyWith(currentOverRuns: [
      ...state!.currentOverRuns,
      updatedOverRuns,
    ]);
  }

  int get remainingBalls {
    if (state == null) return 0;
    if (currentInnings == null) return 6;
    final rBalls = 6 - currentInnings!.remainingBalls;
    return rBalls;
  }

  bool _isCompletedOver(int balls) => balls % 6 == 0;

  bool _isLastOverMaiden(String bowlerId) {
    // Implementation to check if the last over was a maiden
    // This would need to track the runs in the last 6 deliveries for the specific bowler
    return false; // Placeholder
  }

  // Match completion
  void endMatch({
    required String winningTeamId,
    required WinningMethod method,
    required int margin,
  }) {
    if (state == null) return;

    state!.setMatchResult(
      winningTeamId: winningTeamId,
      method: method,
      margin: margin,
    );
  }
}

final matchStateProvider = StateNotifierProvider<MatchStateNotifier, Match?>(
  (ref) {
    return MatchStateNotifier(null);
  },
);
