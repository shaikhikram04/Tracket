import 'package:tracket/players/models/player.dart';
import 'package:tracket/teams/models/team_details.dart';

class PlayerDetails {
  PlayerDetails({
    required this.cricketRole,
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.role,
  });

  final String id;
  final String name;
  final CricketRole cricketRole;
  final String imageUrl;
  final TeamRole role;

  static PlayerDetails fromMap(Map<String, dynamic> playerDetail) =>
      PlayerDetails(
        cricketRole: Player.getCricketRole(playerDetail['cricketRole']),
        id: playerDetail['id'],
        imageUrl: playerDetail['imageUrl'],
        name: playerDetail['name'],
        role: TeamDetails.getTeamRole(playerDetail['role']),
      );

  Map<String, dynamic> get toMap => {
        'id': id,
        'name': name,
        'cricketRole': cricketRole.name,
        'imageUrl': imageUrl,
        'role': role.name,
      };

  PlayerDetails copyWith() {
    return PlayerDetails(
      id: id,
      name: name,
      imageUrl: imageUrl,
      cricketRole: cricketRole,
      role: role,
    );
  }
}
