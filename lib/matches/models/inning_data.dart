class InningsData {
  final List<BatsmanData> batsmen;

  const InningsData({required this.batsmen});
}

class BatsmanData {
  final String name;
  final String dismissalInfo;
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final double strikeRate;

  const BatsmanData({
    required this.name,
    required this.dismissalInfo,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
  });
}