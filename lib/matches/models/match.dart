import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/teams/models/team.dart';
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

class Match {
  Match({
    required this.team1,
    required this.team2,
    required this.noOfPlayer,
    required this.over,
    required this.isTeam1WonToss,
    required this.tossDecision,
    required this.createdAt,
    required this.createdBy,
    required this.matchFormat,
    required this.matchType,
    required this.spectatorsAllowed,
    required this.updatedAt,
    required this.venue,
  })  : id = uuid.v4(),
        inning1 = isTeam1WonToss
            ? (tossDecision == TossDecision.batting
                ? Inning(battingTeam: team1, bowlingTeam: team2)
                : Inning(battingTeam: team2, bowlingTeam: team1))
            : (tossDecision == TossDecision.batting
                ? Inning(battingTeam: team2, bowlingTeam: team1)
                : Inning(battingTeam: team1, bowlingTeam: team2)),
        inning2 = isTeam1WonToss
            ? (tossDecision == TossDecision.batting
                ? Inning(battingTeam: team2, bowlingTeam: team1)
                : Inning(battingTeam: team1, bowlingTeam: team2))
            : (tossDecision == TossDecision.batting
                ? Inning(battingTeam: team1, bowlingTeam: team2)
                : Inning(battingTeam: team2, bowlingTeam: team1));

  final String id;
  final Team team1;
  final Team team2;
  final MatchType matchType;
  final int over;
  final MatchFormat matchFormat;
  final int noOfPlayer;
  final bool isTeam1WonToss;
  final String venue;
  final TossDecision tossDecision;
  final Timestamp createdAt;
  final bool spectatorsAllowed;
  final String createdBy;
  final Timestamp updatedAt;

  Inning inning1;
  Inning inning2;
}
