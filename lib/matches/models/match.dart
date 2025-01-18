import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team_details.dart';
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
    List<PlayerDetails> playerDetails) {
  return playerDetails
      .map((playerDetail) =>
          BattingScore(uuid: playerDetail.id, playerName: playerDetail.name))
      .toList();
}

List<BowlingScore> playerDetailToBowlingScore(
    List<PlayerDetails> playerDetails) {
  return playerDetails
      .map((playerDetail) =>
          BowlingScore(uuid: playerDetail.id, playerName: playerDetail.name))
      .toList();
}

Inning team1BatFirst(TeamDetails team1, TeamDetails team2,
    List<PlayerDetails> team1Players, List<PlayerDetails> team2Players) {
  return Inning(
      battingTeam: team1,
      bowlingTeam: team2,
      battingStats: playerDetailToBattingScore(team1Players),
      bowlingStats: playerDetailToBowlingScore(team2Players));
}

Inning team2BatFirst(TeamDetails team1, TeamDetails team2,
    List<PlayerDetails> team1Players, List<PlayerDetails> team2Players) {
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
      required this.team1Players,
      required this.team2Players,
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
  final TeamDetails team1;
  final TeamDetails team2;
  final List<PlayerDetails> team1Players;
  final List<PlayerDetails> team2Players;
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
}
