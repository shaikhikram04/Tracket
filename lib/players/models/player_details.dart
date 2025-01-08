import 'package:tracket/players/models/player.dart';
import 'package:tracket/teams/models/team_details.dart';

class PlayerDetails {
  PlayerDetails({
    required this.cricketRole,
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.teamRole,
  });

  final String id;
  final String name;
  final CricketRole cricketRole;
  final String imageUrl;
  final TeamRole teamRole;
}
