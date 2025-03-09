import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/extras.dart';
import 'package:tracket/matches/models/fall_of_wickets.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';

// Enum for innings status
enum InningsStatus { notStarted, inProgress, declared, allOut, completed }

class Inning {
  const Inning({
    required this.battingTeam,
    required this.bowlingTeam,
    required this.battingStats,
    required this.bowlingStats,
    required this.strikerPosition,
    required this.nonStrikerPosition,
    required this.currentBowlerId,
    this.fallOfWickets = const [],
    this.balls = 0,
    this.fours = 0,
    this.runs = 0,
    this.sixes = 0,
    this.wickets = 0,
    this.status = InningsStatus.inProgress,
    this.extras = const Extras(),
  });

  final MatchTeamInfo battingTeam;
  final MatchTeamInfo bowlingTeam;
  final List<BattingScore> battingStats;
  final List<BowlingScore> bowlingStats;
  final List<FallOfWicket> fallOfWickets;
  final int runs;
  final int wickets;
  final int balls;
  final Extras extras;
  final int fours;
  final int sixes;
  final InningsStatus status;
  final int strikerPosition;
  final int nonStrikerPosition;
  final String currentBowlerId;

  // Computed properties
  int get completedOvers => balls ~/ 6;
  int get remainingBalls => balls % 6;

  String get oversDisplay => '$completedOvers.${remainingBalls}';

  double get runRate {
    if (balls == 0) return 0.0;
    return (runs * 6.0) / balls;
  }

  // Factory constructor for initialization
  static Inning initialize({
    required MatchTeamInfo battingTeam,
    required MatchTeamInfo bowlingTeam,
    required List<MatchPlayerInfo> battingPlayers,
    required List<MatchPlayerInfo> bowlingPlayers,
    required int strikerPosition,
    required int nonStrikerPosition,
    required String currentBowlerId,
  }) {
    return Inning(
      battingTeam: battingTeam,
      bowlingTeam: bowlingTeam,
      currentBowlerId: currentBowlerId,
      strikerPosition: strikerPosition,
      nonStrikerPosition: nonStrikerPosition,
      battingStats: [],
      bowlingStats: [],
    );
  }

  bool get isInningsCompleted =>
      status == InningsStatus.allOut ||
      status == InningsStatus.declared ||
      status == InningsStatus.completed;

  // State update methods
  Inning addDelivery({
    required int runs,
    required bool isFour,
    required bool isSix,
    bool isWide = false,
    bool isNoBall = false,
    bool isBye = false,
    bool isLegBye = false,
    bool isWicket = false,
    int? outBatsmanPosition,
  }) {
    final newExtras = extras.copyWith(
      wides: extras.wides + (isWide ? 1 : 0),
      noBalls: extras.noBalls + (isNoBall ? 1 : 0),
      byes: extras.byes + (isBye ? runs : 0),
      legByes: extras.legByes + (isLegBye ? runs : 0),
    );

    int newStrikerPosition = strikerPosition;
    int newNonStrikerPosition = nonStrikerPosition;
    int runsForBowler = 0;

    List<BattingScore> newBattingStat = battingStats;
    List<BowlingScore> newBowlingStat = bowlingStats;
    //* Wicket handling:
    if (isWicket) {
      //* If the striker is out (or for run-outs affecting the non-striker)
      if (outBatsmanPosition == null || outBatsmanPosition == strikerPosition) {
        newBattingStat = battingStats.map((player) {
          if (player.battingPosition == strikerPosition) {
            return player.wicket(runs, !isWide);
          }
          return player;
        }).toList();
      } else {
        //* Non-striker gets dismissed (commonly in a run-out).
        newBattingStat = battingStats.map((player) {
          if (player.battingPosition == strikerPosition) {
            return player.addRuns(runs, isFour: isFour, isSix: isSix);
          }
          if (player.battingPosition == nonStrikerPosition) {
            return player.wicket(0, false);
          }
          return player;
        }).toList();
        // newNonStrikerPosition = -1;
      }
    } else {
      //* Add runs only if the delivery is not “extra” (i.e. wide, bye, leg bye,
      //* or a no-ball that resulted in bye/leg bye).
      final shouldAddRuns =
          !(isWide || isBye || isLegBye || (isNoBall && (isBye || isLegBye)));
      if (shouldAddRuns) {
        newBattingStat = battingStats.map((player) {
          if (player.battingPosition == strikerPosition) {
            return player.addRuns(runs, isFour: isFour, isSix: isSix);
          }
          return player;
        }).toList();
      }
    }
    if (runs.isOdd) {
      newStrikerPosition = nonStrikerPosition;
      newNonStrikerPosition = strikerPosition;
    }

    if (isWide) {
      runsForBowler = 1 + runs;
    } else if (isNoBall) {
      if (isBye || isLegBye) {
        runsForBowler = 1;
      } else {
        runsForBowler = 1 + runs;
      }
    } else if (isBye || isLegBye) {
      runsForBowler = 0;
    } else {
      runsForBowler = runs;
    }

    newBowlingStat = bowlingStats.map((player) {
      if (player.uuid == currentBowlerId) {
        return player.addBall(
          runs: runsForBowler,
          isWide: isWide,
          isNoBall: isNoBall,
          isWicket: isWicket,
        );
      }
      return player;
    }).toList();

    return copyWith(
      runs: this.runs + runs,
      balls: isWide || isNoBall ? this.balls : this.balls + 1,
      fours: isFour ? this.fours + 1 : this.fours,
      sixes: isSix ? this.sixes + 1 : this.sixes,
      wickets: isWicket ? this.wickets + 1 : this.wickets,
      extras: newExtras,
      battingStats: newBattingStat,
      bowlingStats: newBowlingStat,
      strikerPosition: newStrikerPosition,
      nonStrikerPosition: newNonStrikerPosition,
    );
  }

  Inning updateInningsStatus(InningsStatus newStatus) {
    return copyWith(status: newStatus);
  }

  Inning addWicket() {
    return copyWith(
      wickets: wickets + 1,
      status:
          wickets + 1 >= battingStats.length ? InningsStatus.allOut : status,
    );
  }

  // Validation methods
  bool isValidDelivery({
    required bool isWide,
    required bool isNoBall,
    required int runs,
  }) {
    if (isWide && isNoBall) return false;
    if (runs > 6 && !isWide && !isNoBall) return false;
    return true;
  }

  bool get hasValidStats {
    final totalRunsFromBoundaries = (fours * 4) + (sixes * 6);
    return totalRunsFromBoundaries <= runs &&
        wickets <= battingStats.length &&
        balls >= 0;
  }

  // Partnership calculation
  List<int> getCurrentPartnership() {
    if (battingStats.isEmpty) return [0, 0];

    final notOutBatsmen = battingStats.where((stats) => !stats.isOut).toList();
    if (notOutBatsmen.length < 2) return [0, 0];

    return [
      notOutBatsmen[0].runs + notOutBatsmen[1].runs,
      notOutBatsmen[0].ballsFaced + notOutBatsmen[1].ballsFaced,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'runs': runs,
      'wickets': wickets,
      'balls': balls,
      'fours': fours,
      'sixes': sixes,
      'extras': extras.toMap(),
      'status': status.name,
      'battingTeam': battingTeam.toMap,
      'bowlingTeam': bowlingTeam.toMap,
      'battingStats': battingStats.map((e) => e.toMap()).toList(),
      'bowlingStats': bowlingStats.map((e) => e.toMap()).toList(),
      'strikerPosition': strikerPosition,
      'nonStrikerPosition': nonStrikerPosition,
      'currentBowlerId': currentBowlerId,
    };
  }

  static Inning fromMap(
    Map<String, dynamic> map, {
    List<QueryDocumentSnapshot>? battingScore,
    List<QueryDocumentSnapshot>? bowlingScore,
  }) {
    return Inning(
      battingTeam: MatchTeamInfo.fromMap(map['battingTeam']),
      bowlingTeam: MatchTeamInfo.fromMap(map['bowlingTeam']),
      battingStats: getBattingScoreFromDocs(battingScore),
      bowlingStats: getBowlingScoreFromDocs(bowlingScore),
      balls: map['balls'],
      fours: map['fours'],
      sixes: map['sixes'],
      runs: map['runs'],
      wickets: map['wickets'],
      status: InningsStatus.values.firstWhere((e) => e.name == map['status']),
      extras: Extras.fromMap(map['extras']),
      strikerPosition: map['strikerPosition'],
      nonStrikerPosition: map['nonStrikerPosition'],
      currentBowlerId: map['currentBowlerId'],
    );
  }

  static List<BattingScore> getBattingScoreFromDocs(
    List<QueryDocumentSnapshot>? battingScoreDoc,
  ) =>
      battingScoreDoc == null
          ? []
          : battingScoreDoc
              .map((doc) =>
                  BattingScore.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

  static List<BowlingScore> getBowlingScoreFromDocs(
    List<QueryDocumentSnapshot>? bowlingScoreDoc,
  ) =>
      bowlingScoreDoc == null
          ? []
          : bowlingScoreDoc
              .map((doc) =>
                  BowlingScore.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

  Inning copyWith({
    MatchTeamInfo? battingTeam,
    MatchTeamInfo? bowlingTeam,
    List<BattingScore>? battingStats,
    List<BowlingScore>? bowlingStats,
    int? balls,
    int? fours,
    int? sixes,
    int? runs,
    int? wickets,
    InningsStatus? status,
    Extras? extras,
    int? strikerPosition,
    int? nonStrikerPosition,
    String? currentBowlerId,
  }) =>
      Inning(
        battingTeam: battingTeam ?? this.battingTeam,
        bowlingTeam: bowlingTeam ?? this.bowlingTeam,
        battingStats: battingStats ?? this.battingStats,
        bowlingStats: bowlingStats ?? this.bowlingStats,
        balls: balls ?? this.balls,
        fours: fours ?? this.balls,
        runs: runs ?? this.runs,
        sixes: sixes ?? this.sixes,
        status: status ?? this.status,
        wickets: wickets ?? this.wickets,
        extras: extras ?? this.extras,
        strikerPosition: strikerPosition ?? this.strikerPosition,
        nonStrikerPosition: nonStrikerPosition ?? this.nonStrikerPosition,
        currentBowlerId: currentBowlerId ?? this.currentBowlerId,
      );
}
