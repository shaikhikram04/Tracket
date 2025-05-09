import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/features/matches/models/batting_score.dart';
import 'package:tracket/features/matches/models/bowling_score.dart';
import 'package:tracket/features/matches/models/extras.dart';
import 'package:tracket/features/matches/models/fall_of_wickets.dart';
import 'package:tracket/features/matches/models/inning/delivery_processor.dart';
import 'package:tracket/features/matches/models/match_team_info.dart';

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
      status == InningsStatus.allOut || status == InningsStatus.declared || status == InningsStatus.completed;

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

  // Main method to add a delivery - delegates to specialized handlers
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
    // Use the DeliveryProcessor to handle all the logic
    final processor = DeliveryProcessor(this);

    return processor.processDelivery(
      runs: runs,
      isFour: isFour,
      isSix: isSix,
      isOverCompleted: isOverCompleted,
      isInningCompleted: isInningCompleted,
      isWide: isWide,
      isNoBall: isNoBall,
      isBye: isBye,
      isLegBye: isLegBye,
      isWicket: isWicket,
      outBatsmanPosition: outBatsmanPosition,
      reasonOfOut: reasonOfOut,
      dismissalInfo: dismissalInfo,
    );
  }

  Inning updateInningsStatus(InningsStatus newStatus) {
    return copyWith(status: newStatus);
  }

  bool isWicketDownAtNow() {
    final strikers = battingStats
        .where((batsman) => batsman.battingPosition == strikerPosition || batsman.battingPosition == nonStrikerPosition)
        .toList();

    return (strikers[0].isOut || strikers[1].isOut);
  }

  // Partnership calculation
  List<int> getCurrentPartnership() {

    //! Not right logic : need to correct
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
      'fallOfWickets': fallOfWickets.map((fallOfWicket) => fallOfWicket.toMap()).toList()
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

    return fallOfWickets.map((fallOfWicketMap) => FallOfWicket.fromMap(fallOfWicketMap)).toList();
  }

  static List<BattingScore> getBattingScoreFromDocs(
    List<QueryDocumentSnapshot>? battingScoreDoc,
  ) =>
      battingScoreDoc == null
          ? []
          : battingScoreDoc.map((doc) => BattingScore.fromMap(doc.data() as Map<String, dynamic>)).toList();

  static List<BowlingScore> getBowlingScoreFromDocs(
    List<QueryDocumentSnapshot>? bowlingScoreDoc,
  ) =>
      bowlingScoreDoc == null
          ? []
          : bowlingScoreDoc.map((doc) => BowlingScore.fromMap(doc.data() as Map<String, dynamic>)).toList();

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
