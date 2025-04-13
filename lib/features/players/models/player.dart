import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/features/players/models/player_cricket_detail.dart';

class Player {
  final String id;
  final String email;
  final String name;
  final String role;
  final List following;
  final List followers;
  final List followingTeams;
  final String profileImageUrl;
  final Timestamp createdAt;
  final PlayerCricketDetails? playerCricketDetails;

  Player({
    required this.role,
    required this.id,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.following,
    required this.followingTeams,
    required this.followers,
    required this.createdAt,
    required this.playerCricketDetails,
  });

  Player.user({
    required this.role,
    required this.id,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.createdAt,
    required this.following,
    required this.followers,
    required this.followingTeams,
  }) : playerCricketDetails = null;

  Map<String, dynamic> get toJsonForPlayer => {
        'playerId': id,
        'email': email,
        'playerName': name,
        'role': role,
        'profileImageUrl': profileImageUrl,
        'createdAt': createdAt,
        'following': following,
        'followingTeams': followingTeams,
        'followers': followers,
        'playerCricketDetails': playerCricketDetails?.toMap,
      };

  List<String> get playerTeamsId {
    List<String>? teamsId = [];
    teamsId = playerCricketDetails?.teams.map((team) => team.id).toList();

    return teamsId ?? [];
  }

  Map<String, dynamic> get toJsonForUser => {
        'userId': id,
        'email': email,
        'username': name,
        'role': role,
        'profileImageUrl': profileImageUrl,
        'createdAt': createdAt,
        'following': following,
        'followers': followers,
        'followingTeams': followingTeams,
      };

  static Player fromSeed(
      Map<String, dynamic> snap, List<QueryDocumentSnapshot>? playerTeams) {
    return Player(
      role: snap['role'],
      id: snap['playerId'],
      name: snap['playerName'],
      email: snap['email'],
      profileImageUrl: snap['profileImageUrl'],
      createdAt: snap['createdAt'],
      following: snap['following'],
      followingTeams: snap['followingTeams'],
      followers: snap['followers'],
      playerCricketDetails: PlayerCricketDetails.fromMap(
          snap['playerCricketDetails'], playerTeams),
    );
  }

  static Player fromSeedForUser(Map<String, dynamic> snap) {
    return Player.user(
      role: snap['role'],
      id: snap['userId'],
      name: snap['playerName'],
      email: snap['email'],
      profileImageUrl: snap['profileImageUrl'],
      createdAt: snap['createdAt'],
      following: snap['following'],
      followingTeams: snap['followingTeams'],
      followers: snap['followers'],
    );
  }
}
