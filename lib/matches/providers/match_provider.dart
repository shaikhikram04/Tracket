import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';

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
    );
  }

  void setMatch(Match match) {
    state = match;
  }

  //* Sets the toss result and decision.
  void setTossResult({required bool isTeam1Won, required TossDecision decision}) {
    if (state == null) return;

    state = state!.copyWith(
      isTeam1WonToss: isTeam1Won,
      tossDecision: decision,
    );
  }

  void updateMatchStatus(MatchStatus status) {
    if (state == null) return;

    state = state!.copyWith(status: status);
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
    return MatchStateNotifier(null, ref);
  },
);
