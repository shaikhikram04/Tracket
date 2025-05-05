import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/features/matches/models/ball_outcome.dart';
import 'package:tracket/features/matches/models/inning.dart';
import 'package:tracket/features/matches/models/match_player_info.dart';
import 'package:tracket/features/matches/models/match_team_info.dart';
import 'package:tracket/features/matches/models/team_score.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:uuid/uuid.dart';

enum TossDecision { batting, fielding }

enum MatchType { friendly, practice, challenged }

enum MatchFormat { over5, over10, over20, over50, test }

enum MatchStatus { scheduled, live, completed, abandoned, cancelled }

enum WinningMethod { byRuns, byWickets, tied, noResult }

const uuid = Uuid();

class Match {
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
  final MatchStatus status;
  final String? winningTeamId;
  final WinningMethod? winningMethod;
  final int? winningMargin;
  final int? currentInningNumber;
  final List participants;
  final String challengerPlayerId;
  final String challengeAcceptedBy;
  final String? startBy;
  final TeamScore? team1Score;
  final TeamScore? team2Score;

  Match({
    required this.id,
    required this.team1,
    required this.team2,
    required this.team1Players,
    required this.team2Players,
    required this.noOfPlayer,
    required this.matchFormat,
    required this.matchType,
    required this.venue,
    required this.schedule,
    required this.participants,
    required this.challengerPlayerId,
    required this.challengeAcceptedBy,
    required this.updatedAt,
    required this.createdAt,
    this.startBy,
    this.isTeam1WonToss,
    this.tossDecision,
    this.winningMargin,
    this.winningMethod,
    this.winningTeamId,
    this.currentInningNumber,
    this.spectatorsAllowed = true,
    this.status = MatchStatus.scheduled,
    this.team1Score,
    this.team2Score,
  });

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

  String matchCompleteStatement() {
    if (winningMethod == WinningMethod.byRuns ||
        winningMethod == WinningMethod.byWickets) {
      final winningTeamName =
          winningTeamId == team1.teamId ? team1.teamName : team2.teamName;

      final wayToWin =
          '$winningMargin ${winningMethod == WinningMethod.byRuns ? TTextStrings.runs : TTextStrings.wickets}';

      return '$winningTeamName won by $wayToWin';
    } else if (winningMethod == WinningMethod.noResult) {
      return TTextStrings.noResult;
    } else if (winningMethod == WinningMethod.tied) {
      return TTextStrings.matchTied;
    } else {
      return '';
    }
  }

  // Team and player management
  MatchTeamInfo? get battingTeam {
    if (currentInningNumber == null && isTeam1WonToss == null) return null;
    if (currentInningNumber == 1 && isTeam1WonToss != null) {
      return _getTossWinnerTeam(TossDecision.batting);
    } else {
      return _getTossWinnerTeam(TossDecision.fielding);
    }
  }

  MatchTeamInfo? get battingTeamBeforeInnStart {
    if (currentInningNumber == null && isTeam1WonToss == null) return null;

    if (currentInningNumber == null && isTeam1WonToss != null) {
      return _getTossWinnerTeam(TossDecision.batting);
    } else {
      return _getTossWinnerTeam(TossDecision.fielding);
    }
  }

  MatchTeamInfo? get bowlingTeam {
    if (currentInningNumber == null && isTeam1WonToss == null) return null;
    if (currentInningNumber == 1 && isTeam1WonToss != null) {
      return _getTossWinnerTeam(TossDecision.fielding);
    } else {
      return _getTossWinnerTeam(TossDecision.batting);
    }
  }

  MatchTeamInfo? get bowlingTeamBeforeInnStart {
    if (currentInningNumber == null && isTeam1WonToss == null) return null;
    if (currentInningNumber == null && isTeam1WonToss != null) {
      return _getTossWinnerTeam(TossDecision.fielding);
    } else {
      return _getTossWinnerTeam(TossDecision.batting);
    }
  }

  String get winningTeamName {
    if (winningTeamId == null) return '';
    return winningTeamId == team1.teamId ? team1.teamName : team2.teamName;
  }

  String get losingTeamName {
    if (winningTeamId == null) return '';
    return winningTeamId == team1.teamId ? team2.teamName : team1.teamName;
  }

  List<MatchPlayerInfo> get winningTeamPlayers {
    if (winningTeamId == null) return [];
    return winningTeamId == team1.teamId ? team1Players : team2Players;
  }

  TeamScore? get inning1Score {
    final batTeam = _getTossWinnerTeam(TossDecision.batting);
    if (batTeam?.teamId == team1.teamId) {
      return team1Score;
    } else {
      return team2Score;
    }
  }

  TeamScore? get inning2Score {
    final batTeam = _getTossWinnerTeam(TossDecision.fielding);
    if (batTeam?.teamId == team1.teamId) {
      return team1Score;
    } else {
      return team2Score;
    }
  }

  List<MatchPlayerInfo> getBattingTeamPlayers() {
    if (battingTeam == null) return [];
    return battingTeam!.teamId == team1.teamId ? team1Players : team2Players;
  }

  List<MatchPlayerInfo> getBattingTeamPlayersBeforeInnStart() {
    if (battingTeam == null) return [];
    return battingTeamBeforeInnStart!.teamId == team1.teamId
        ? team1Players
        : team2Players;
  }

  List<MatchPlayerInfo> getBowlingTeamPlayers() {
    if (bowlingTeam == null) return [];
    return bowlingTeam!.teamId == team1.teamId ? team1Players : team2Players;
  }

  List<MatchPlayerInfo> getBowlingTeamPlayersBeforeInnStar() {
    if (bowlingTeam == null) return [];
    return bowlingTeamBeforeInnStart!.teamId == team1.teamId
        ? team1Players
        : team2Players;
  }

  // Match initialization methods
  Inning initializeFirstInnings({
    required String bowlerId,
  }) {
    if (tossDecision == null || isTeam1WonToss == null) {
      throw StateError(TTextStrings.tossNotDone);
    }

    final inning1 = Inning.initialize(
      battingTeam: battingTeam!,
      bowlingTeam: bowlingTeam!,
      currentBowlerId: bowlerId,
      strikerPosition: 1,
      nonStrikerPosition: 2,
    );

    return inning1;
  }

  Inning initializeSecondInnings({
    required String bowlerId,
  }) {
    if (currentInningNumber == null) {
      throw StateError(TTextStrings.inningsNotStarted);
    }

    final inning2 = Inning.initialize(
      battingTeam: battingTeam!,
      bowlingTeam: bowlingTeam!,
      strikerPosition: 1,
      nonStrikerPosition: 2,
      currentBowlerId: bowlerId,
    );

    return inning2;
  }

  Match setTossDecision(TossDecision decision, bool _isTeam1WonToss) {
    return copyWith(
      tossDecision: decision,
      isTeam1WonToss: _isTeam1WonToss,
    );
  }

  Match setMatchResult({
    required String? winningTeamId,
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
  MatchTeamInfo? _getTossWinnerTeam(TossDecision decision) {
    if (isTeam1WonToss == null || tossDecision == null) {
      return null;
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

  static List<MatchPlayerInfo> getPlayers(List players) {
    return players.map((e) => MatchPlayerInfo.fromMap(e)).toList();
  }

  Map<String, dynamic> get toMap => {
        'id': id,
        'team1': team1.toMap,
        'team2': team2.toMap,
        'team1Players': team1Players.map((e) => e.toMap).toList(),
        'team2Players': team2Players.map((e) => e.toMap).toList(),
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
        'currentInningNumber': currentInningNumber,
        'participants': participants,
        'challengerPlayerId': challengerPlayerId,
        'challengeAcceptedBy': challengeAcceptedBy,
        'startBy': startBy,
        'team1Score': team1Score?.toMap(),
        'team2Score': team2Score?.toMap(),
      };

  factory Match.fromMap(Map<String, dynamic> map) {
    return Match(
      id: map['id'],
      team1: MatchTeamInfo.fromMap(map['team1']),
      team2: MatchTeamInfo.fromMap(map['team2']),
      team1Players: getPlayers(map['team1Players']),
      team2Players: getPlayers(map['team2Players']),
      noOfPlayer: map['noOfPlayer'],
      matchFormat:
          MatchFormat.values.firstWhere((e) => e.name == map['matchFormat']),
      matchType: MatchType.values.firstWhere((e) => e.name == map['matchType']),
      venue: map['venue'],
      schedule: map['schedule'].toDate(),
      participants: map['participants'],
      isTeam1WonToss: map['isTeam1WonToss'],
      tossDecision: map['tossDecision'] != null
          ? TossDecision.values.firstWhere((e) => e.name == map['tossDecision'])
          : null,
      status: MatchStatus.values.firstWhere((e) => e.name == map['status']),
      winningTeamId: map['winningTeamId'],
      winningMethod: map['winningMethod'] != null
          ? WinningMethod.values
              .firstWhere((e) => e.name == map['winningMethod'])
          : null,
      winningMargin: map['winningMargin'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      spectatorsAllowed: map['spectatorsAllowed'],
      challengerPlayerId: map['challengerPlayerId'],
      challengeAcceptedBy: map['challengeAcceptedBy'],
      startBy: map['startBy'],
      currentInningNumber: map['currentInningNumber'],
      team1Score: TeamScore.fromMap(map['team1Score']),
      team2Score: TeamScore.fromMap(map['team2Score']),
    );
  }

  Match copyWith({
    List<BallOutcome?>? currentOverRuns,
    bool? isTeam1WonToss,
    TossDecision? tossDecision,
    MatchStatus? status,
    String? winningTeamId,
    WinningMethod? winningMethod,
    int? winningMargin,
    List<MatchPlayerInfo>? team1Players,
    List<MatchPlayerInfo>? team2Players,
    List<String>? participants,
    String? challengerPlayerId,
    String? challengeAcceptedBy,
    int? currentInningNumber,
    TeamScore? team1Score,
    TeamScore? team2Score,
    String? startedBy,
  }) {
    return Match(
      id: id,
      team1: team1,
      team2: team2,
      team1Players: team1Players ?? this.team1Players,
      team2Players: team2Players ?? this.team2Players,
      noOfPlayer: noOfPlayer,
      matchFormat: matchFormat,
      matchType: matchType,
      venue: venue,
      schedule: schedule,
      isTeam1WonToss: isTeam1WonToss ?? this.isTeam1WonToss,
      tossDecision: tossDecision ?? this.tossDecision,
      status: status ?? this.status,
      winningTeamId: winningTeamId ?? this.winningTeamId,
      winningMethod: winningMethod ?? this.winningMethod,
      winningMargin: winningMargin ?? this.winningMargin,
      participants: participants ?? this.participants,
      challengerPlayerId: challengerPlayerId ?? this.challengerPlayerId,
      challengeAcceptedBy: challengeAcceptedBy ?? this.challengeAcceptedBy,
      createdAt: createdAt,
      currentInningNumber: currentInningNumber ?? this.currentInningNumber,
      updatedAt: Timestamp.now(),
      team1Score: team1Score ?? this.team1Score,
      team2Score: team2Score ?? this.team2Score,
      startBy: startedBy ?? this.startBy,
    );
  }
}
