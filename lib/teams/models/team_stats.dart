class TeamStats {
  final int matchesPlayed;
  final int wins;
  final int losses;

  const TeamStats({
    this.matchesPlayed = 0,
    this.wins = 0,
    this.losses = 0,

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
  }) {
    return TeamStats(
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
    );
  }

  Map<String, dynamic> toJson() => {
        'matches': matchesPlayed,
        'wins': wins,
        'losses': losses,
      };

  factory TeamStats.fromJson(Map<String, dynamic> json) {
    return TeamStats(
      matchesPlayed: json['matches'] ?? 0,
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
    );
  }
}
