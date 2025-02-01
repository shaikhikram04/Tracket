import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team_request_status.dart';
import 'package:tracket/teams/models/team_role.dart';
import 'package:tracket/teams/models/team_stats.dart';

class Team {
  final String id;
  final String name;
  final String shortName;
  final String createdBy;
  final String logoUrl;
  final List<PlayerDetails> playersList;
  final String captainId;
  final String wicketkeeperId;
  final TeamStats stats;
  final List<dynamic> achievements;
  final List<String> followers;
  final int maxPlayersCapacity;
  final String description;
  final TeamRequestStatus requestStatus;
  final bool isPrivate;
  final List<String> playerIds;
  final List<String> requestedPlayers;
  final List<String> challengedTeams;

  const Team({
    required this.id,
    required this.name,
    required this.shortName,
    required this.logoUrl,
    required this.playersList,
    required this.createdBy,
    this.captainId = '',
    this.wicketkeeperId = '',
    TeamStats? stats,
    List<dynamic>? achievements,
    List<String>? followers,
    this.maxPlayersCapacity = 15,
    this.description = '',
    TeamRequestStatus? requestStatus,
    this.isPrivate = false,
    List<String>? playerIds,
    List<String>? requestedPlayers,
    List<String>? challengedTeams,
  })  : stats = stats ?? const TeamStats(),
        achievements = achievements ?? const [],
        followers = followers ?? const [],
        requestStatus = requestStatus ?? const TeamRequestStatus(),
        playerIds = playerIds ?? const [],
        requestedPlayers = requestedPlayers ?? const [],
        challengedTeams = challengedTeams ?? const [];

  List<PlayerDetails> get admins =>
      playersList.where((player) => player.role != TeamRole.player).toList();

  List<PlayerDetails> get nonAdmins =>
      playersList.where((player) => player.role == TeamRole.player).toList();

  bool get hasCapacity => playersList.length < maxPlayersCapacity;

  static List<PlayerDetails> _parseTeamPlayers(
      List<QueryDocumentSnapshot>? players) {
    if (players == null) return [];
    return players
        .map((player) =>
            PlayerDetails.fromMap(player.data() as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'teamName': name,
        'shortName': shortName,
        'createdBy': createdBy,
        'logoUrl': logoUrl,
        'captainId': captainId,
        'wicketkeeperId': wicketkeeperId,
        ...stats.toJson(),
        'achievements': achievements,
        'followers': followers,
        'maxPlayersCapacity': maxPlayersCapacity,
        'description': description,
        ...requestStatus.toJson(),
        'isPrivate': isPrivate,
        'playersIds': playerIds,
        'requestedPlayers': requestedPlayers,
        'challengedTeams': challengedTeams,
      };

  factory Team.fromJson(
    Map<String, dynamic> json,
    List<QueryDocumentSnapshot>? teamPlayers,
  ) {
    return Team(
      id: json['id'],
      name: json['teamName'],
      shortName: json['shortName'],
      logoUrl: json['logoUrl'],
      playersList: _parseTeamPlayers(teamPlayers),
      createdBy: json['createdBy'],
      captainId: json['captainId'] ?? '',
      wicketkeeperId: json['wicketkeeperId'] ?? '',
      stats: TeamStats.fromJson(json),
      achievements: json['achievements'] ?? [],
      followers: List<String>.from(json['followers'] ?? []),
      maxPlayersCapacity: json['maxPlayersCapacity'] ?? 15,
      description: json['description'] ?? '',
      requestStatus: TeamRequestStatus.fromJson(json),
      isPrivate: json['isPrivate'] ?? false,
      playerIds: List<String>.from(json['playersIds'] ?? []),
      requestedPlayers: List<String>.from(json['requestedPlayers'] ?? []),
      challengedTeams: List<String>.from(json['challengedTeams'] ?? []),
    );
  }

  Team copyWith({
    String? name,
    String? shortName,
    String? logoUrl,
    List<PlayerDetails>? playersList,
    String? captainId,
    String? wicketkeeperId,
    TeamStats? stats,
    List<dynamic>? achievements,
    List<String>? followers,
    int? maxPlayersCapacity,
    String? description,
    TeamRequestStatus? requestStatus,
    bool? isPrivate,
    List<String>? playerIds,
    List<String>? requestedPlayers,
    List<String>? challengedTeams,
  }) {
    return Team(
      id: id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      logoUrl: logoUrl ?? this.logoUrl,
      playersList: playersList ?? this.playersList,
      createdBy: createdBy,
      captainId: captainId ?? this.captainId,
      wicketkeeperId: wicketkeeperId ?? this.wicketkeeperId,
      stats: stats ?? this.stats,
      achievements: achievements ?? this.achievements,
      followers: followers ?? this.followers,
      maxPlayersCapacity: maxPlayersCapacity ?? this.maxPlayersCapacity,
      description: description ?? this.description,
      requestStatus: requestStatus ?? this.requestStatus,
      isPrivate: isPrivate ?? this.isPrivate,
      playerIds: playerIds ?? this.playerIds,
      requestedPlayers: requestedPlayers ?? this.requestedPlayers,
      challengedTeams: challengedTeams ?? this.challengedTeams,
    );
  }

  static formSeed(Map<String, dynamic> teamData, param1) {}
}
