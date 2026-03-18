/// Enum defining the different types of actions this button can perform
enum ActionButtonType {
  addPlayer,
  joinTeam,
  addAdmin,
}

enum StatsDataSize {
  small,
  medium,
  large,
}

enum HighlightSize {
  small, // Compact size
  medium, // Default size
  large // Larger size
}

// Enum for innings status
enum InningsStatus { notStarted, inProgress, declared, allOut, completed }

/// Defines the types of balls that can be bowled in cricket.
enum BallType {
  valid,
  wide,
  noBall,
  bye,
  legBye,
  // dead
}

enum ReasonOfOut {
  bowled('Bowled'),
  lbw('LBW'),
  stumped('Stumped'),
  hitWicket('Hit Wicket'),
  caught('Caught'),
  runOut('Run Out');

  const ReasonOfOut(this.description);
  final String description;
}

enum TossDecision { batting, fielding }

enum MatchType { friendly, practice, challenged }

enum MatchFormat { over5, over10, over20, over50, test }

enum MatchStatus { scheduled, live, completed, abandoned, cancelled }

enum WinningMethod { byRuns, byWickets, tied, noResult }

enum SelectionType { batsman, bowler }

enum MatchesFetcherType {
  userMatches,
  completed,
  live,
  upcoming,
}

enum NotificationType {
  follow,
  teamJoinRequest, //* player request to join team
  offerPlayerRequest, //* team offer player to join team
  matchChallenge,
}

enum NotificationStatus {
  pending,
  accept,
  reject;

  bool get isPending => this == NotificationStatus.pending;
  bool get isAccepted => this == NotificationStatus.accept;
  bool get isReject => this == NotificationStatus.reject;
}

enum CricketRole {
  batsman('Batsman'),
  bowler('Bowler'),
  allRounder('All-Rounder'),
  wicketKeeper('Wicketkeeper');

  const CricketRole(this.description);
  final String description;
}

enum Position {
  righty,
  lefty,
}

enum BowlingStyle {
  none,
  fast,
  mediumFast,
  legSpin,
  offSpin,
  chinaMan,
}

enum TeamRole {
  owner('owner'),
  admin('admin'),
  player('player'),
  none('none');

  final String value;
  const TeamRole(this.value);

  static TeamRole fromString(String value) {
    return TeamRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => TeamRole.none,
    );
  }
}
