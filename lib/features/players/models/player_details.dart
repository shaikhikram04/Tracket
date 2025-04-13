import 'package:tracket/features/players/models/player_cricket_detail.dart';
import 'package:tracket/features/teams/models/team_details.dart';
import 'package:tracket/features/teams/models/team_role.dart';

class PlayerDetails {
  PlayerDetails({
    required this.cricketRole,
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.role,
    required this.longCricketRole,
  });

  final String id;
  final String name;
  final CricketRole cricketRole;
  final String imageUrl;
  final TeamRole role;
  final String longCricketRole;

  static PlayerDetails fromMap(Map<String, dynamic> playerDetail) =>
      PlayerDetails(
        cricketRole:
            PlayerCricketDetails.getCricketRole(playerDetail['cricketRole']),
        id: playerDetail['id'],
        imageUrl: playerDetail['imageUrl'],
        name: playerDetail['name'],
        role: TeamDetails.getTeamRole(playerDetail['role']),
        longCricketRole: playerDetail['longCricketRole'],
      );

  Map<String, dynamic> get toMap => {
        'id': id,
        'name': name,
        'cricketRole': cricketRole.name,
        'imageUrl': imageUrl,
        'role': role.name,
        'longCricketRole': longCricketRole
      };

  PlayerDetails copyWith() {
    return PlayerDetails(
      id: id,
      name: name,
      imageUrl: imageUrl,
      cricketRole: cricketRole,
      role: role,
      longCricketRole: longCricketRole,
    );
  }
}
