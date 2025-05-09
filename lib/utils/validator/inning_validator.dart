import 'package:tracket/features/matches/models/inning/inning.dart';

/// Service class for validating cricket match statistics
class InningValidationService {
  /// Validate complete inning data
  static bool validateInning(Inning inning) {
    return validateScoring(inning) && validateBattingStats(inning) && validateBowlingStats(inning);
  }

  /// Validate the scoring consistency
  static bool validateScoring(Inning inning) {
    // Total runs should match with individual components
    int totalBattingRuns = _calculateTotalBattingRuns(inning);
    int totalExtras = inning.extras.total;

    return inning.runs == (totalBattingRuns + totalExtras);
  }

  /// Calculate total runs from batsmen
  static int _calculateTotalBattingRuns(Inning inning) {
    return inning.battingStats.fold(0, (sum, batsman) => sum + batsman.runs);
  }

  /// Validate batting statistics consistency
  static bool validateBattingStats(Inning inning) {
    // Check boundary counts
    int totalFoursFromBatsmen = inning.battingStats.fold(0, (sum, batsman) => sum + batsman.fours);
    int totalSixesFromBatsmen = inning.battingStats.fold(0, (sum, batsman) => sum + batsman.sixes);

    return inning.fours == totalFoursFromBatsmen && inning.sixes == totalSixesFromBatsmen;
  }

  /// Validate bowling statistics consistency
  static bool validateBowlingStats(Inning inning) {
    // Total deliveries from bowlers should match inning balls (accounting for extras)
    int totalDeliveries = _calculateTotalDeliveriesFromBowlers(inning);
    int totalWidesAndNoBalls = inning.extras.wides + inning.extras.noBalls;

    return (totalDeliveries + totalWidesAndNoBalls) == inning.balls;
  }

  /// Calculate total deliveries from bowlers
  static int _calculateTotalDeliveriesFromBowlers(Inning inning) {
    return inning.bowlingStats.fold(0, (sum, bowler) => sum + bowler.overs * 6 + bowler.balls);
  }
}
