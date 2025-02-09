import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
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
      striker: null,
      nonStriker: null,
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

    state!.initializeFirstInnings();
    state = state;
  }

  void startSecondInnings() {
    if (state == null) return;

    state!.initializeSecondInnings();
    state = state;
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
    final batsmanIndex = battingStats.indexWhere((stats) => stats.uuid == batsmanId);
    
    if (batsmanIndex == -1) return;

    final updatedBattingStats = List<BattingScore>.from(battingStats);
    updatedBattingStats[batsmanIndex] = battingStats[batsmanIndex].copyWith(
      runs: (battingStats[batsmanIndex].runs ?? 0) + runs,
      ballsFaced: (battingStats[batsmanIndex].ballsFaced ?? 0) + ballsFaced,
      fours: isFour ? (battingStats[batsmanIndex].fours ?? 0) + 1 : battingStats[batsmanIndex].fours,
      sixes: isSix ? (battingStats[batsmanIndex].sixes ?? 0) + 1 : battingStats[batsmanIndex].sixes,
    );

    _updateInnings(battingStats: updatedBattingStats);
  }

  void addRuns(int runs) {}

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
}

final matchStateProvider = StateNotifierProvider<MatchStateNotifier, Match?>(
  (ref) {
    return MatchStateNotifier(null);
  },
);
