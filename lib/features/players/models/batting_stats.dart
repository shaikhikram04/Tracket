class BattingStats {
  final int? innings;
  final int totalRuns;
  final int ballsFaced;
  final int? highestScore;
  final int? hundreds;
  final int? fifties;
  final int four;
  final int six;
  final int? outCount;

  const BattingStats({
    this.totalRuns = 0,
    this.ballsFaced = 0,
    this.highestScore = 0,
    this.hundreds = 0,
    this.fifties = 0,
    this.four = 0,
    this.six = 0,
    this.innings = 0,
    this.outCount = 0,
  });

  const BattingStats.matchStats({
    this.totalRuns = 0,
    this.ballsFaced = 0,
    this.four = 0,
    this.six = 0,
  })  : innings = null,
        highestScore = null,
        hundreds = null,
        fifties = null,
        outCount = null;

  double get strikeRate {
    if (ballsFaced == 0) {
      return 0;
    }
    return (totalRuns / ballsFaced) * 100;
  }

  double get battingAverage {
    if (outCount == 0) {
      return totalRuns.toDouble();
    }

    return totalRuns / outCount!;
  }

  Map<String, dynamic> get toJson => {
        'totalRuns': totalRuns,
        'ballsFaced': ballsFaced,
        'highestScore': highestScore,
        'hundreds': hundreds,
        'fifties': fifties,
        'four': four,
        'six': six,
        'innings': innings,
        'outCount': outCount,
      };

  static BattingStats fromMap(Map<String, dynamic> snap) {
    return BattingStats(
      ballsFaced: snap['ballFaced'] ?? snap['ballsFaced'],
      fifties: snap['fifties'],
      four: snap['four'],
      highestScore: snap['highestScore'],   
      hundreds: snap['hundreds'],
      innings: snap['innings'],
      outCount: snap['outCount'],
      six: snap['six'],
      totalRuns: snap['totalRuns'],
    );
  }
}
