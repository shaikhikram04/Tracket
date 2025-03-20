import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/extras.dart';
import 'package:tracket/matches/models/fall_of_wickets.dart';
import 'package:tracket/matches/models/match_team_info.dart';

// Enum for innings status
enum InningsStatus { notStarted, inProgress, declared, allOut, completed }

class Inning {
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

  // Computed properties
  int get completedOvers => balls ~/ 6;
  int get remainingBalls => balls % 6;

  String get oversDisplay => '$completedOvers.$remainingBalls';

  double get runRate {
    if (balls == 0) return 0.0;
    return (runs * 6.0) / balls;
  }

  

  bool get isInningsCompleted =>
      status == InningsStatus.allOut ||
      status == InningsStatus.declared ||
      status == InningsStatus.completed;

  // Factory constructor for initialization
  factory Inning.initialize({
    required MatchTeamInfo battingTeam,
    required MatchTeamInfo bowlingTeam,
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

  // State update methods
  Inning addDelivery({
    required int runs,
    required bool isFour,
    required bool isSix,
    required bool isOverCompleted,
    required bool isInningCompleted,
    bool isWide = false,
    bool isNoBall = false,
    bool isBye = false,
    bool isLegBye = false,
    bool isWicket = false,
    int? outBatsmanPosition,
    ReasonOfOut? reasonOfOut,
    String? dismissalInfo,
  }) {
    if (!_isValidDelivery(isWide: isWide, isNoBall: isNoBall, runs: runs)) {
      throw ArgumentError('Invalid delivery parameters');
    }

    final newExtras = extras.addExtras(
      isWide: isWide,
      isNoBall: isNoBall,
      isBye: isBye,
      isLegBye: isLegBye,
      runs: runs,
    );

    int newStrikerPosition = strikerPosition;
    int newNonStrikerPosition = nonStrikerPosition;
    String outBatsmanName = '';

    final runsForBowler = _calculateRunsForBowler(
      runs: runs,
      isWide: isWide,
      isNoBall: isNoBall,
      isBye: isBye,
      isLegBye: isLegBye,
    );

    final newBattingStats = _updateBattingStats(
      runs: runs,
      isFour: isFour,
      isSix: isSix,
      isWide: isWide,
      isWicket: isWicket,
      isBye: isBye,
      isLegBye: isLegBye,
      isNoBall: isNoBall,
      outBatsmanPosition: outBatsmanPosition,
      reasonOfOut: reasonOfOut,
      dismissalInfo: dismissalInfo,
      outBatsmanNameCallback: (name) => outBatsmanName = name,
    );

    // Update bowling statistics
    final newBowlingStats = _updateBowlingStats(
      runsForBowler: runsForBowler,
      isWide: isWide,
      isNoBall: isNoBall,
      isWicket: reasonOfOut == ReasonOfOut.runOut ? false : isWicket,
    );

    if ((runs.isOdd && !isOverCompleted) || (isOverCompleted && runs.isEven)) {
      newStrikerPosition = nonStrikerPosition;
      newNonStrikerPosition = strikerPosition;
    }

    // Create fall of wicket if applicable
    FallOfWicket? fallOfWicket;
    if (isWicket) {
      fallOfWicket = FallOfWicket(
        wicketNumber: wickets + 1,
        runsAtFall: this.runs + runs,
        batsmanName: outBatsmanName,
        balls: isWide || isNoBall ? this.balls : this.balls + 1,
      );
    }

    return copyWith(
      runs: this.runs + runs,
      balls: isWide || isNoBall ? this.balls : this.balls + 1,
      fours: isFour ? this.fours + 1 : this.fours,
      sixes: isSix ? this.sixes + 1 : this.sixes,
      wickets: isWicket ? this.wickets + 1 : this.wickets,
      extras: newExtras,
      battingStats: newBattingStats,
      bowlingStats: newBowlingStats,
      strikerPosition: newStrikerPosition,
      nonStrikerPosition: newNonStrikerPosition,
      status: isInningCompleted ? InningsStatus.completed : this.status,
      fallOfWickets: isWicket
          ? [...this.fallOfWickets, fallOfWicket!]
          : this.fallOfWickets,
    );
  }

  Inning updateInningsStatus(InningsStatus newStatus) {
    return copyWith(status: newStatus);
  }

  /// Validates whether a delivery configuration is valid
  bool _isValidDelivery({
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

  /// Calculate runs to be charged to the bowler
  int _calculateRunsForBowler({
    required int runs,
    required bool isWide,
    required bool isNoBall,
    required bool isBye,
    required bool isLegBye,
  }) {
    if (isWide) {
      return 1 + runs; // Wide + any additional runs
    } else if (isNoBall) {
      if (isBye || isLegBye) {
        return 1; // Just the no-ball penalty
      } else {
        return 1 + runs; // No-ball + any runs scored
      }
    } else if (isBye || isLegBye) {
      return 0; // Byes/leg-byes aren't charged to the bowler
    } else {
      return runs; // Normal runs charged to the bowler
    }
  }

  /// Update batting statistics based on the delivery
  List<BattingScore> _updateBattingStats({
    required int runs,
    required bool isFour,
    required bool isSix,
    required bool isWide,
    required bool isWicket,
    required bool isBye,
    required bool isLegBye,
    required bool isNoBall,
    int? outBatsmanPosition,
    ReasonOfOut? reasonOfOut,
    String? dismissalInfo,
    required Function(String) outBatsmanNameCallback,
  }) {
    if (isWicket) {
      return _updateBattingStatsWithWicket(
        runs: runs,
        isFour: isFour,
        isSix: isSix,
        isWide: isWide,
        outBatsmanPosition: outBatsmanPosition,
        reasonOfOut: reasonOfOut!,
        dismissalInfo: dismissalInfo,
        outBatsmanNameCallback: outBatsmanNameCallback,
      );
    } else {
      // Should runs be added to batsman's score?
      final shouldAddRuns =
          !(isWide || isBye || isLegBye || (isNoBall && (isBye || isLegBye)));

      if (shouldAddRuns) {
        return battingStats.map((player) {
          if (player.battingPosition == strikerPosition) {
            return player.addRuns(runs, isFour: isFour, isSix: isSix);
          }
          return player;
        }).toList();
      }

      return battingStats;
    }
  }

  /// Update batting stats when a wicket falls
  List<BattingScore> _updateBattingStatsWithWicket({
    required int runs,
    required bool isFour,
    required bool isSix,
    required bool isWide,
    required int? outBatsmanPosition,
    required ReasonOfOut reasonOfOut,
    String? dismissalInfo,
    required Function(String) outBatsmanNameCallback,
  }) {
    // If outBatsmanPosition is null or equals striker, the striker is out
    if (outBatsmanPosition == null || outBatsmanPosition == strikerPosition) {
      return battingStats.map((player) {
        if (player.battingPosition == strikerPosition) {
          outBatsmanNameCallback(player.playerName);
          return player.wicket(
            runs,
            countBall: !isWide,
            reasonOfOut: reasonOfOut,
            dismissalInfo: dismissalInfo,
          );
        }
        return player;
      }).toList();
    } else {
      // Non-striker is out (typically in a run-out)
      return battingStats.map((player) {
        if (player.battingPosition == strikerPosition) {
          return player.addRuns(runs, isFour: isFour, isSix: isSix);
        }
        if (player.battingPosition == nonStrikerPosition) {
          outBatsmanNameCallback(player.playerName);
          return player.wicket(
            0,
            countBall: false,
            reasonOfOut: reasonOfOut,
            dismissalInfo: dismissalInfo,
          );
        }
        return player;
      }).toList();
    }
  }

  /// Update bowling statistics based on the delivery
  List<BowlingScore> _updateBowlingStats({
    required int runsForBowler,
    required bool isWide,
    required bool isNoBall,
    required bool isWicket,
  }) {
    return bowlingStats.map((player) {
      if (player.uuid == currentBowlerId) {
        return player.addBall(
          runs: player.runsGiven + runsForBowler,
          isWide: isWide,
          isNoBall: isNoBall,
          isWicket: isWicket,
        );
      }
      return player;
    }).toList();
  }

  bool isWicketDownAtNow() {
    final strikers = battingStats
        .where((batsman) =>
            batsman.battingPosition == strikerPosition ||
            batsman.battingPosition == nonStrikerPosition)
        .toList();

    return (strikers[0].isOut || strikers[1].isOut);
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
      'strikerPosition': strikerPosition,
      'nonStrikerPosition': nonStrikerPosition,
      'currentBowlerId': currentBowlerId,
      'fallOfWickets':
          fallOfWickets.map((fallOfWicket) => fallOfWicket.toMap()).toList()
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
      fallOfWickets: getFallOfWickets(map['fallOfWickets']),
    );
  }

  static List<FallOfWicket> getFallOfWickets(List? fallOfWickets) {
    if (fallOfWickets == null || fallOfWickets.isEmpty) return [];

    return fallOfWickets
        .map((fallOfWicketMap) => FallOfWicket.fromMap(fallOfWicketMap))
        .toList();
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
    List<FallOfWicket>? fallOfWickets,
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
        fallOfWickets: fallOfWickets ?? this.fallOfWickets,
      );
}
