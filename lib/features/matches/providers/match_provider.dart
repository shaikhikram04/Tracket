import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/matches/models/match.dart';
import 'package:tracket/features/matches/models/match_player_info.dart';
import 'package:tracket/features/matches/models/match_team_info.dart';
import 'package:tracket/features/matches/models/team_score.dart';
import 'package:tracket/utils/constants/enums.dart';

class MatchStateNotifier extends StateNotifier<Match?> {
  MatchStateNotifier(super.state, this.ref);
  final Ref ref;

  //* Creates a new match with the provided configuration.
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
    required String challengerPlayerId,
    required String challengeAcceptedBy,
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
      participants: [team1.teamId, team2.teamId],
      challengerPlayerId: challengerPlayerId,
      challengeAcceptedBy: challengeAcceptedBy,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      id: uuid.v4(),
    );
  }

  void setMatch(Match match, String startedBy) {
    state = match.copyWith(startedBy: startedBy);
  }

  //* updates team score
  void updateTeamScore(TeamScore teamScore) {
    if (state == null) return;

    final battingTeam = state!.battingTeam;
    if (battingTeam == null) return;

    if (battingTeam.teamId == state!.team1.teamId) {
      state = state!.copyWith(team1Score: teamScore);
    } else {
      state = state!.copyWith(team2Score: teamScore);
    }
  }

  //* Sets the toss result and decision.
  void setTossResult(
      {required bool isTeam1Won, required TossDecision decision}) {
    if (state == null) return;

    state = state!.setTossDecision(decision, isTeam1Won);
  }

  void updateMatchStatus(MatchStatus status) {
    if (state == null) return;

    state = state!.copyWith(status: status);
  }

  void startFirstInning() {
    if (state == null) return;

    final match = state!;
    final isTeam1BattingFirst =
        match.battingTeamBeforeInnStart?.teamId == match.team1.teamId;
    final initialScore = TeamScore(runs: 0, balls: 0, wickets: 0);

    state = match.copyWith(
      currentInningNumber: 1,
      status: MatchStatus.live,
      team1Score: isTeam1BattingFirst == true ? initialScore : match.team1Score,
      team2Score:
          isTeam1BattingFirst == false ? initialScore : match.team2Score,
    );
  }

  void startSecondInning() {
    if (state == null) return;

    final match = state!;
    final isTeam1BattingSecond =
        match.bowlingTeam?.teamId == match.team1.teamId;
    final initialScore = TeamScore(runs: 0, balls: 0, wickets: 0);

    state = match.copyWith(
      currentInningNumber: 2,
      team1Score:
          isTeam1BattingSecond == true ? initialScore : match.team1Score,
      team2Score:
          isTeam1BattingSecond == false ? initialScore : match.team2Score,
    );
  }

  // Match completion
  void endMatch({
    required String? winningTeamId,
    required WinningMethod method,
    required int margin,
  }) {
    if (state == null) return;

    state = state!.setMatchResult(
      winningTeamId: winningTeamId,
      method: method,
      margin: margin,
    );
  }
}

final matchStateProvider = StateNotifierProvider<MatchStateNotifier, Match?>(
  (ref) {
    return MatchStateNotifier(null, ref);
  },
);
