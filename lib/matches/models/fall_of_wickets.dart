class FallOfWicket {
  final int wicketNumber;
  final int runsAtFall;
  final String batsmanName;
  final double? overs;

  const FallOfWicket({
    required this.wicketNumber,
    required this.runsAtFall,
    required this.batsmanName,
    this.overs,
  });
}