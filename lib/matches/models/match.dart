import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:uuid/uuid.dart';

enum TossDecision {
  batting,
  fielding,
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
  final int over;
  final int noOfPlayer;
  final bool isTeam1WonToss;
  final TossDecision tossDecision;

  Inning inning1;
  Inning inning2;
}
