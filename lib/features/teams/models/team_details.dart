import 'package:tracket/features/teams/models/team_role.dart';
import 'package:tracket/utils/constants/text_strings.dart';

class TeamDetails {
  TeamDetails({
    required this.id,
    required this.logoUrl,
    required this.name,
    required this.shortName,
    required this.role,
  });

  final String id;
  final String name;
  final String shortName;
  final String logoUrl;
  final TeamRole role;

  static TeamDetails formMap(Map<String, dynamic> teamDetails) {
    return TeamDetails(
      id: teamDetails['id'],
      logoUrl: teamDetails['logoUrl'],
      name: teamDetails['name'],
      shortName: teamDetails['shortName'],
      role: getTeamRole(teamDetails['role']),
    );
  }

  static TeamRole getTeamRole(String teamRole) {
    switch (teamRole) {
      case TTextStrings.owner:
        return TeamRole.owner;
      case TTextStrings.admin:
        return TeamRole.admin;
      case TTextStrings.playerRole:
        return TeamRole.player;
      default:
        return TeamRole.none;
    }
  }

  TeamDetails copyWith({
    String? name,
    String? shortName,
    String? logoUrl,
    TeamRole? role,
  }) {
    return TeamDetails(
      id: id,
      logoUrl: logoUrl ?? this.logoUrl,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> get toMap => {
        'id': id,
        'name': name,
        'shortName': shortName,
        'logoUrl': logoUrl,
        'role': role.name,
      };
}
