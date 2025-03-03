import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/extras.dart';
import 'package:tracket/matches/models/fall_of_wickets.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';

List<T> initializeStats<T>(
    List<MatchPlayerInfo> players, T Function(MatchPlayerInfo) builder) {
  return players.map(builder).toList();
}

// Enum for innings status
enum InningsStatus { notStarted, inProgress, declared, allOut, completed }

class Inning {
  const Inning({
    required this.battingTeam,
    required this.bowlingTeam,
    required this.battingStats,
    required this.bowlingStats,
    required this.strikerIndex,
    required this.nonStrikerIndex,
    required this.currentBowlerIndex,
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
  final int strikerIndex;
  final int nonStrikerIndex;
  final int currentBowlerIndex;

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
    required int strikerIndex,
    required int nonStrikerIndex,
    required int currentBowlerIndex,
  }) {
    return Inning(
      battingTeam: battingTeam,
      bowlingTeam: bowlingTeam,
      battingStats: initializeStats<BattingScore>(
        battingPlayers,
        (player) => BattingScore(
          uuid: player.playerId,
          playerName: player.playerName,
        ),
      ),
      bowlingStats: initializeStats<BowlingScore>(
        bowlingPlayers,
        (player) => BowlingScore(
          uuid: player.playerId,
          playerName: player.playerName,
        ),
      ),
      currentBowlerIndex: currentBowlerIndex,
      strikerIndex: strikerIndex,
      nonStrikerIndex: nonStrikerIndex,
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
  }) {
    final newExtras = extras.copyWith(
      wides: extras.wides + (isWide ? 1 : 0),
      noBalls: extras.noBalls + (isNoBall ? 1 : 0),
      byes: extras.byes + (isBye ? runs : 0),
      legByes: extras.legByes + (isLegBye ? runs : 0),
    );

    return copyWith(
      runs: this.runs + runs,
      balls: isWide || isNoBall ? this.balls : this.balls + 1,
      fours: isFour ? this.fours + 1 : this.fours,
      sixes: isSix ? this.sixes + 1 : this.sixes,
      wickets: isWicket ? this.wickets + 1 : this.wickets,
      extras: newExtras,
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
      notOutBatsmen[0].runs! + notOutBatsmen[1].runs!,
      notOutBatsmen[0].ballsFaced! + notOutBatsmen[1].ballsFaced!,
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
      'strikerIndex': strikerIndex,
      'nonStrikerIndex': nonStrikerIndex,
      'currentBowlerIndex': currentBowlerIndex,
    };
  }

  static Inning fromMap(Map<String, dynamic> map) {
    return Inning(
      battingTeam: MatchTeamInfo.fromMap(map['battingTeam']),
      bowlingTeam: MatchTeamInfo.fromMap(map['bowlingTeam']),
      battingStats:
          map['battingStats'].map((e) => BattingScore.fromMap(e)).toList(),
      bowlingStats:
          map['bowlingStats'].map((e) => BowlingScore.fromMap(e)).toList(),
      balls: map['balls'],
      fours: map['fours'],
      sixes: map['sixes'],
      runs: map['runs'],
      wickets: map['wickets'],
      status: InningsStatus.values.firstWhere((e) => e.name == map['status']),
      extras: Extras.fromMap(map['extras']),
      strikerIndex: map['strikerIndex'],
      nonStrikerIndex: map['nonStrikerIndex'],
      currentBowlerIndex: map['currentBowlerIndex'],
    );
  }

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
    int? strikerIndex,
    int? nonStrikerIndex,
    int? currentBowlerIndex,
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
        strikerIndex: strikerIndex ?? this.strikerIndex,
        nonStrikerIndex: nonStrikerIndex ?? this.nonStrikerIndex,
        currentBowlerIndex: currentBowlerIndex ?? this.currentBowlerIndex,
      );
}
