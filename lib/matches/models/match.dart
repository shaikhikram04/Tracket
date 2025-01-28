import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:uuid/uuid.dart';

enum TossDecision {
  batting,
  fielding,
}

enum MatchType {
  friendly,
  practice,
  challenged,
}

enum MatchFormat {
  over5,
  over10,
  over20,
  over50,
  test,
}

enum MatchStatus {
  scheduled,
  live,
  completed,
}

const uuid = Uuid();

List<BattingScore> playerDetailToBattingScore(
    List<MatchPlayerInfo> playerDetails) {
  return playerDetails
      .map((playerDetail) => BattingScore(
          uuid: playerDetail.playerId, playerName: playerDetail.playerName))
      .toList();
}

List<BowlingScore> playerDetailToBowlingScore(
    List<MatchPlayerInfo> playerDetails) {
  return playerDetails
      .map((playerDetail) =>
          BowlingScore(uuid: playerDetail.playerId, playerName: playerDetail.playerName))
      .toList();
}

Inning team1BatFirst(MatchTeamInfo team1, MatchTeamInfo team2,
    List<MatchPlayerInfo> team1Players, List<MatchPlayerInfo> team2Players) {
  return Inning(
      battingTeam: team1,
      bowlingTeam: team2,
      battingStats: playerDetailToBattingScore(team1Players),
      bowlingStats: playerDetailToBowlingScore(team2Players));
}

Inning team2BatFirst(MatchTeamInfo team1, MatchTeamInfo team2,
    List<MatchPlayerInfo> team1Players, List<MatchPlayerInfo> team2Players) {
  return Inning(
      battingTeam: team2,
      bowlingTeam: team1,
      battingStats: playerDetailToBattingScore(team2Players),
      bowlingStats: playerDetailToBowlingScore(team1Players));
}

class Match {
  Match(
      {required this.team1,
      required this.team2,
      required this.noOfPlayer,
      required this.isTeam1WonToss,
      required this.tossDecision,
      required this.createdAt,
      required this.matchFormat,
      required this.matchType,
      required this.spectatorsAllowed,
      required this.updatedAt,
      required this.venue,
      required this.schedule})
      : id = uuid.v4(),
        inning1 = null,
        inning2 = null;

  final String id;
  final MatchTeamInfo team1;
  final MatchTeamInfo team2;
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

  Inning? inning1;
  Inning? inning2;

  int get over {
    switch (matchFormat) {
      case MatchFormat.over5:
        return 5;
      case MatchFormat.over10:
        return 10;
      case MatchFormat.over20:
        return 20;
      case MatchFormat.over50:
        return 50;
      case MatchFormat.test:
        return 90;
    }
  }

  static MatchFormat getMatchFormat(String matchFormat) {
    for (final format in MatchFormat.values) {
      if (matchFormat == format.name) return format;
    }

    return MatchFormat.over20;
  }

  static MatchType getMatchType(String strMatchType) {
    for (final type in MatchType.values) {
      if (type.name == strMatchType) return type;
    }

    return MatchType.practice;
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
      };
}
