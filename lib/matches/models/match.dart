import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/matches/models/ball_outcome.dart';
import 'package:tracket/matches/models/current_player.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:uuid/uuid.dart';

enum TossDecision { batting, fielding }

enum MatchType { friendly, practice, challenged }

enum MatchFormat { over5, over10, over20, over50, test }

enum MatchStatus { scheduled, live, completed, abandoned, cancelled }

enum WinningMethod { byRuns, byWickets, byDls, tied, noResult }

const uuid = Uuid();

class Match {
  Match({
    required this.team1,
    required this.team2,
    required this.team1Players,
    required this.team2Players,
    required this.noOfPlayer,
    required this.matchFormat,
    required this.matchType,
    required this.venue,
    required this.schedule,
    required this.striker,
    required this.nonStriker,
    required this.currentBowlers,
    this.currentOverRuns = const [],
    this.isTeam1WonToss,
    this.tossDecision,
    this.inning1,
    this.inning2,
    this.winningMargin,
    this.winningMethod,
    this.winningTeamId,
    this.spectatorsAllowed = true,
    this.status = MatchStatus.scheduled,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? id,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? Timestamp.now(),
        updatedAt = updatedAt ?? Timestamp.now();

  final String id;
  final MatchTeamInfo team1;
  final MatchTeamInfo team2;
  final List<MatchPlayerInfo> team1Players;
  final List<MatchPlayerInfo> team2Players;
  final MatchType matchType;
  final MatchFormat matchFormat;
  final int noOfPlayer;
  final bool? isTeam1WonToss;
  final String venue;
  final TossDecision? tossDecision;
  final Timestamp createdAt;
  final bool spectatorsAllowed;
  final Timestamp updatedAt;
  final DateTime schedule;
  final List<BallOutcome> currentOverRuns;
  final StrikerData? striker;
  final StrikerData? nonStriker;
  final CurrentBowlerData? currentBowlers;

  final MatchStatus status;
  final Inning? inning1;
  final Inning? inning2;
  final String? winningTeamId;
  final WinningMethod? winningMethod;
  final int? winningMargin;

  // Match configuration getters
  int get over => switch (matchFormat) {
        MatchFormat.over5 => 5,
        MatchFormat.over10 => 10,
        MatchFormat.over20 => 20,
        MatchFormat.over50 => 50,
        MatchFormat.test => 90,
      };

  bool get isTest => matchFormat == MatchFormat.test;

  // Match state getters
  bool get hasStarted => status != MatchStatus.scheduled;
  bool get isCompleted => status == MatchStatus.completed;
  bool get isCancelled => status == MatchStatus.cancelled;
  bool get isInProgress => status == MatchStatus.live;

  // Team and player management
  MatchTeamInfo get battingTeam {
    if (inning1 == null) return _getTossWinnerTeam(TossDecision.batting);
    return inning1!.battingTeam;
  }

  MatchTeamInfo get bowlingTeam {
    if (inning1 == null) return _getTossWinnerTeam(TossDecision.fielding);
    return inning1!.bowlingTeam;
  }

  List<MatchPlayerInfo> getBattingTeamPlayers() {
    return battingTeam.teamId == team1.teamId ? team1Players : team2Players;
  }

  List<MatchPlayerInfo> getBowlingTeamPlayers() {
    return bowlingTeam.teamId == team1.teamId ? team1Players : team2Players;
  }

  int get inningNumber {
    if (inning2 != null) return 2;

    if (inning1 != null) return 1;

    return 0;
  }

  int? get target {
    if (inning2 != null) return inning1!.runs;

    return null;
  }

  // Match initialization methods
  Match initializeFirstInnings() {
    if (tossDecision == null || isTeam1WonToss == null) {
      throw StateError('Toss details must be set before initializing innings');
    }

    final tossWinnerBatting = tossDecision == TossDecision.batting;
    final team1Batting = (isTeam1WonToss! && tossWinnerBatting) ||
        (!isTeam1WonToss! && !tossWinnerBatting);

    final inning1 = team1Batting
        ? Inning.initialize(
            battingTeam: team1,
            bowlingTeam: team2,
            battingPlayers: team1Players,
            bowlingPlayers: team2Players,
          )
        : Inning.initialize(
            battingTeam: team2,
            bowlingTeam: team1,
            battingPlayers: team2Players,
            bowlingPlayers: team1Players,
          );

    final status = MatchStatus.live;

    return copyWith(inning1: inning1, status: status);
  }

  Match initializeSecondInnings() {
    if (inning1 == null) {
      throw StateError(
          'First innings must be completed before starting second innings');
    }

    final inning2 = Inning.initialize(
      battingTeam: inning1!.bowlingTeam,
      bowlingTeam: inning1!.battingTeam,
      battingPlayers: getBowlingTeamPlayers(),
      bowlingPlayers: getBattingTeamPlayers(),
    );

    return copyWith(inning2: inning2);
  }

  // Match state management
  Match updateMatchStatus(MatchStatus newStatus) {
    final status = newStatus;

    return copyWith(status: status);
  }

  Match setMatchResult({
    required String winningTeamId,
    required WinningMethod method,
    required int margin,
  }) {
    final _winningTeamId = winningTeamId;
    final winningMethod = method;
    final winningMargin = margin;

    final status = MatchStatus.completed;

    return copyWith(
      winningTeamId: _winningTeamId,
      winningMethod: winningMethod,
      winningMargin: winningMargin,
      status: status,
    );
  }

  // Helper methods
  MatchTeamInfo _getTossWinnerTeam(TossDecision decision) {
    if (isTeam1WonToss == null || tossDecision == null) {
      throw StateError('Toss details not set');
    }

    if (decision == tossDecision) {
      return isTeam1WonToss! ? team1 : team2;
    } else {
      return isTeam1WonToss! ? team2 : team1;
    }
  }

  // Static format helpers
  static MatchFormat getMatchFormat(String matchFormat) {
    return MatchFormat.values.firstWhere(
      (format) => format.name == matchFormat,
      orElse: () => MatchFormat.over20,
    );
  }

  static MatchType getMatchType(String matchType) {
    return MatchType.values.firstWhere(
      (type) => type.name == matchType,
      orElse: () => MatchType.practice,
    );
  }

  Map<String, dynamic> get toMap => {
        'id': id,
        'team1': team1.toMap,
        'team2': team2.toMap,
        'matchType': matchType.name,
        'matchFormat': matchFormat.name,
        'noOfPlayer': noOfPlayer,
        'isTeam1WonToss': isTeam1WonToss,
        'venue': venue,
        'tossDecision': tossDecision?.name,
        'createdAt': createdAt,
        'spectatorsAllowed': spectatorsAllowed,
        'updatedAt': updatedAt,
        'schedule': Timestamp.fromDate(schedule),
        'status': status.name,
        'winningTeamId': winningTeamId,
        'winningMethod': winningMethod?.name,
        'winningMargin': winningMargin,
        'currentOverRuns': currentOverRuns.map((e) => e.toMap()).toList(),
      };

  Match copyWith({
    StrikerData? striker,
    StrikerData? nonStriker,
    CurrentBowlerData? currentBowler,
    List<BallOutcome>? currentOverRuns,
    bool? isTeam1WonToss,
    TossDecision? tossDecision,
    Inning? inning1,
    Inning? inning2,
    MatchStatus? status,
    String? winningTeamId,
    WinningMethod? winningMethod,
    int? winningMargin,
  }) {
    return Match(
      team1: team1,
      team2: team2,
      team1Players: team1Players,
      team2Players: team2Players,
      noOfPlayer: noOfPlayer,
      matchFormat: matchFormat,
      matchType: matchType,
      venue: venue,
      schedule: schedule,
      striker: striker ?? this.striker,
      nonStriker: nonStriker ?? this.nonStriker,
      currentBowlers: currentBowler ?? this.currentBowlers,
      currentOverRuns: currentOverRuns ?? this.currentOverRuns,
      isTeam1WonToss: isTeam1WonToss ?? this.isTeam1WonToss,
      tossDecision: tossDecision ?? this.tossDecision,
      inning1: inning1 ?? this.inning1,
      inning2: inning2 ?? this.inning2,
      status: status ?? this.status,
      winningTeamId: winningTeamId ?? this.winningTeamId,
      winningMethod: winningMethod ?? this.winningMethod,
      winningMargin: winningMargin ?? this.winningMargin,
    );
  }
}
