import 'package:tracket/features/matches/models/batting_score.dart';
import 'package:tracket/features/matches/models/bowling_score.dart';
import 'package:tracket/features/matches/models/inning/inning.dart';

/// Service class for calculating cricket match statistics
class InningStatsCalculator {
  final Inning inning;

  InningStatsCalculator(this.inning);

  /// Get current run rate
  double getCurrentRunRate() {
    if (inning.balls == 0) return 0.0;
    return (inning.runs * 6.0) / inning.balls;
  }

  /// Calculate required run rate to achieve target
  double getRequiredRunRate(int target, int maxOvers) {
    int runsNeeded = target - inning.runs;
    if (runsNeeded <= 0) return 0.0;

    double oversRemaining = maxOvers - (inning.balls / 6);
    if (oversRemaining <= 0) return double.infinity;

    return runsNeeded / oversRemaining;
  }

  /// Get current partnership details
  Map<String, dynamic> getCurrentPartnershipDetails() {
    // Get current batsmen at crease
    final currentBatsmen = inning.battingStats
        .where((player) =>
            player.battingPosition == inning.strikerPosition || player.battingPosition == inning.nonStrikerPosition)
        .toList();

    if (currentBatsmen.length < 2) {
      return {'runs': 0, 'balls': 0, 'batsmen': []};
    }

    // Calculate partnership stats
    int partnershipRuns = currentBatsmen.fold(0, (sum, player) => sum + player.runs);
    int partnershipBalls = currentBatsmen.fold(0, (sum, player) => sum + player.ballsFaced);

    return {
      'runs': partnershipRuns,
      'balls': partnershipBalls,
      'batsmen': currentBatsmen
          .map((player) => {'name': player.playerName, 'runs': player.runs, 'balls': player.ballsFaced})
          .toList()
    };
  }

  /// Get top performers in the innings
  Map<String, dynamic> getTopPerformers() {
    // Find top batsman
    BattingScore? topBatsman;
    if (inning.battingStats.isNotEmpty) {
      topBatsman = inning.battingStats.reduce((curr, next) => curr.runs > next.runs ? curr : next);
    }

    // Find top bowler (by wickets, then economy)
    BowlingScore? topBowler;
    if (inning.bowlingStats.isNotEmpty) {
      topBowler = _findTopBowler();
    }

    return {
      'topBatsman': topBatsman != null
          ? {
              'name': topBatsman.playerName,
              'runs': topBatsman.runs,
              'balls': topBatsman.ballsFaced,
              'fours': topBatsman.fours,
              'sixes': topBatsman.sixes
            }
          : null,
      'topBowler': topBowler != null
          ? {
              'name': topBowler.playerName,
              'wickets': topBowler.wickets,
              'runs': topBowler.runsGiven,
              'overs': topBowler.overs + (topBowler.balls / 6)
            }
          : null
    };
  }

  /// Find the top bowler based on wickets and economy
  BowlingScore _findTopBowler() {
    // First prioritize by wickets
    var bowlersByWickets = List<BowlingScore>.from(inning.bowlingStats)..sort((a, b) => b.wickets.compareTo(a.wickets));

    // If multiple bowlers have same top wickets, sort by economy
    int topWickets = bowlersByWickets.first.wickets;
    var topWicketTakers = bowlersByWickets.where((bowler) => bowler.wickets == topWickets).toList();

    if (topWicketTakers.length == 1) {
      return topWicketTakers.first;
    }

    // Sort by economy for bowlers with same wickets
    topWicketTakers.sort((a, b) {
      double economyA = a.runsGiven / ((a.overs * 6 + a.balls) / 6);
      double economyB = b.runsGiven / ((b.overs * 6 + b.balls) / 6);
      return economyA.compareTo(economyB);
    });

    return topWicketTakers.first;
  }

  /// Generate inning summary
  Map<String, dynamic> getInningSummary() {
    return {
      'team': inning.battingTeam.teamName,
      'score': '${inning.runs}/${inning.wickets}',
      'overs': inning.oversDisplay,
      'runRate': getCurrentRunRate().toStringAsFixed(2),
      'extras': inning.extras.total,
      'fours': inning.fours,
      'sixes': inning.sixes,
      'status': inning.status.name,
    };
  }
}
