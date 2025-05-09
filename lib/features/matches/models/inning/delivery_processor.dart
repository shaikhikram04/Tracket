// File: lib/features/matches/models/delivery_processor.dart
import 'package:tracket/features/matches/models/batting_score.dart';
import 'package:tracket/features/matches/models/bowling_score.dart';
import 'package:tracket/features/matches/models/fall_of_wickets.dart';
import 'package:tracket/features/matches/models/inning/inning.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/constants/text_strings.dart';

/// Class responsible for processing cricket deliveries
///
/// This class encapsulates all the logic for updating statistics
/// when a delivery occurs in a cricket match
class DeliveryProcessor {
  final Inning inning;
  String _outBatsmanName = '';

  DeliveryProcessor(this.inning);

  /// Main method to process a delivery and return an updated Inning
  Inning processDelivery({
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
      throw ArgumentError(TTextStrings.inValidDeliveryParameter);
    }

    // Calculate updated values
    final newExtras = inning.extras.addExtras(
      isWide: isWide,
      isNoBall: isNoBall,
      isBye: isBye,
      isLegBye: isLegBye,
      runs: runs,
    );

    // Calculate who gets the strike after this delivery
    final strikePair = _calculateNewStrikePair(
      runs: runs,
      isWide: isWide,
      isNoBall: isNoBall,
      isOverCompleted: isOverCompleted,
    );

    // Calculate runs charged to bowler
    final runsForBowler = _calculateRunsForBowler(
      runs: runs,
      isWide: isWide,
      isNoBall: isNoBall,
      isBye: isBye,
      isLegBye: isLegBye,
    );

    // Update batting statistics
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
    );

    // Update bowling statistics
    final newBowlingStats = _updateBowlingStats(
      runsForBowler: runsForBowler,
      isWide: isWide,
      isNoBall: isNoBall,
      isWicket: reasonOfOut == ReasonOfOut.runOut ? false : isWicket,
    );

    // Create fall of wicket if applicable
    FallOfWicket? fallOfWicket;
    if (isWicket) {
      fallOfWicket = FallOfWicket(
        wicketNumber: inning.wickets + 1,
        runsAtFall: inning.runs + runs,
        batsmanName: _outBatsmanName,
        balls: isWide || isNoBall ? inning.balls : inning.balls + 1,
      );
    }

    // Return updated inning
    return inning.copyWith(
      runs: inning.runs + runs,
      balls: isWide || isNoBall ? inning.balls : inning.balls + 1,
      fours: isFour ? inning.fours + 1 : inning.fours,
      sixes: isSix ? inning.sixes + 1 : inning.sixes,
      wickets: isWicket ? inning.wickets + 1 : inning.wickets,
      extras: newExtras,
      battingStats: newBattingStats,
      bowlingStats: newBowlingStats,
      strikerPosition: strikePair[0],
      nonStrikerPosition: strikePair[1],
      status: isInningCompleted ? InningsStatus.completed : inning.status,
      fallOfWickets: isWicket ? [...inning.fallOfWickets, fallOfWicket!] : inning.fallOfWickets,
    );
  }

  /// Calculates the new striker and non-striker positions based on delivery outcome
  List<int> _calculateNewStrikePair({
    required int runs,
    required bool isWide,
    required bool isNoBall,
    required bool isOverCompleted,
  }) {
    int newStrikerPosition = inning.strikerPosition;
    int newNonStrikerPosition = inning.nonStrikerPosition;

    final runsExcludeExtras = isNoBall || isWide ? runs - 1 : runs;

    if ((runsExcludeExtras.isOdd && !isOverCompleted) || (isOverCompleted && runsExcludeExtras.isEven)) {
      newStrikerPosition = inning.nonStrikerPosition;
      newNonStrikerPosition = inning.strikerPosition;
    }

    return [newStrikerPosition, newNonStrikerPosition];
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
      );
    } else {
      // Should runs be added to batsman's score?
      final shouldAddRuns = !(isWide || isBye || isLegBye || (isNoBall && (isBye || isLegBye)));

      if (shouldAddRuns) {
        return inning.battingStats.map((player) {
          if (player.battingPosition == inning.strikerPosition) {
            return player.addRuns(runs, isFour: isFour, isSix: isSix);
          }
          return player;
        }).toList();
      }

      return inning.battingStats;
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
  }) {
    // If outBatsmanPosition is null or equals striker, the striker is out
    if (outBatsmanPosition == null || outBatsmanPosition == inning.strikerPosition) {
      return inning.battingStats.map((player) {
        if (player.battingPosition == inning.strikerPosition) {
          _outBatsmanName = player.playerName;
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
      return inning.battingStats.map((player) {
        if (player.battingPosition == inning.strikerPosition) {
          return player.addRuns(runs, isFour: isFour, isSix: isSix);
        }
        if (player.battingPosition == inning.nonStrikerPosition) {
          _outBatsmanName = player.playerName;
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
    return inning.bowlingStats.map((player) {
      if (player.uuid == inning.currentBowlerId) {
        return player.addBall(
          runs: runsForBowler,
          isWide: isWide,
          isNoBall: isNoBall,
          isWicket: isWicket,
        );
      }
      return player;
    }).toList();
  }
}
