enum TeamRole {
  owner,
  admin,
  player,
}

class TeamDetails {
  TeamDetails({
    required this.id,
    required this.logoUrl,
    required this.name,
    required this.shortName,
    required this.teamRole,
  });
  
  final String id;
  final String name;
  final String shortName;
  final String logoUrl;
  final TeamRole teamRole;
}
