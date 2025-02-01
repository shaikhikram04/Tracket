class TeamStats {
  final int matchesPlayed;
  final int wins;
  final int losses;
  final int rank;

  const TeamStats({
    this.matchesPlayed = 0,
    this.wins = 0,
    this.losses = 0,
    this.rank = -1,
  });

  double get winningPercentage {
    if (matchesPlayed == 0) return 0.0;
    return (wins / matchesPlayed) * 100;
  }

  int get tie {
    return matchesPlayed - (wins + losses);
  }

  TeamStats copyWith({
    int? matchesPlayed,
    int? wins,
    int? losses,
    int? tieCount,
    int? rank,
  }) {
    return TeamStats(
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      rank: rank ?? this.rank,
    );
  }

  Map<String, dynamic> toJson() => {
        'matches': matchesPlayed,
        'wins': wins,
        'losses': losses,
        'rank': rank,
      };

  factory TeamStats.fromJson(Map<String, dynamic> json) {
    return TeamStats(
      matchesPlayed: json['matches'] ?? 0,
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
      rank: json['rank'] ?? -1,
    );
  }
}
