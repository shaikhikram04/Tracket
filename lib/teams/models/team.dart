import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  Team({
    required this.id,
    required this.name,
    required this.shortName,
    required this.logoUrl,
    required this.playersList,
    required this.achievements,
    required this.following,
    required this.followers,
    this.captainId,
    this.wicketkeeperId,
    required this.createdBy,
    this.losses = 0,
    this.matchesPlayed = 0,
    this.tieCount = 0,
    this.wins = 0,
    this.rank = -1,
    this.maxPlayersCapacity = 15,
    this.description = '',
    this.sendRequest = 0,
    this.pendingRequest = 0,
    this.isPrivate = false,
  });

  final String id;
  final String name;
  final String shortName;
  final String createdBy;
  final String? logoUrl;
  final int rank;
  final List<Map<String, dynamic>> playersList;
  final String? captainId;
  final String? wicketkeeperId;
  final int matchesPlayed;
  final int wins;
  final int losses;
  final int tieCount;
  final List achievements;
  final List following;
  final List followers;
  final int maxPlayersCapacity;
  final String description;
  final int sendRequest;
  final int pendingRequest;
  final bool isPrivate;

  List get admins => playersList
      .where((player) => player['role'] == 'admin' || player['role'] == 'owner')
      .toList();

  List get nonAdmins => playersList
      .where((player) => player['role'] != 'admin' && player['role'] != 'owner')
      .toList();

  int get winningPercent {
    return ((wins / matchesPlayed) * 100).toInt();
  }

  static List<Map<String, dynamic>> teamPlayersToList(
      List<QueryDocumentSnapshot>? players) {
    if (players == null) return [];
    return players.map(
      (player) {
        final playerInfo = player.data() as Map<String, dynamic>;
        return {
          'cricketRole': playerInfo['cricketRole'],
          'id': playerInfo['id'],
          'name': playerInfo['name'],
          'imageUrl': playerInfo['imageUrl'],
          'role': playerInfo['role'],
        };
      },
    ).toList();
  }

  Map<String, dynamic> get toJson => {
        'id': id,
        'teamName': name,
        'shortName': shortName,
        'createdBy': createdBy,
        'logoUrl': logoUrl,
        'rank': rank,
        'captainId': captainId,
        'wicketkeeperId': wicketkeeperId,
        'matches': matchesPlayed,
        'wins': wins,
        'losses': losses,
        'tie': tieCount,
        'achievements': achievements,
        'following': following,
        'followers': followers,
        'maxPlayersCapacity': maxPlayersCapacity,
        'description': description,
        'sendRequest': sendRequest,
        'pendingRequest': pendingRequest,
        'isPrivate': isPrivate,
      };

  static Team formSeed(Map<String, dynamic> snap,
          List<QueryDocumentSnapshot>? teamPlayers) =>
      Team(
        id: snap['id'],
        name: snap['teamName'],
        shortName: snap['shortName'],
        logoUrl: snap['logoUrl'],
        playersList: teamPlayersToList(teamPlayers),
        createdBy: snap['createdBy'],
        captainId: snap['captainId'],
        losses: snap['losses'],
        matchesPlayed: snap['matches'],
        rank: snap['rank'],
        tieCount: snap['tie'],
        wicketkeeperId: snap['wicketkeeperId'],
        wins: snap['wins'],
        achievements: snap['achievements'],
        following: snap['following'],
        followers: snap['followers'],
        maxPlayersCapacity: snap['maxPlayersCapacity'],
        description: snap['description'],
        sendRequest: snap['sendRequest'],
        pendingRequest: snap['pendingRequest'],
        isPrivate: snap['isPrivate'],
      );

  Team copyWith({
    String? name,
    String? shortName,
    String? logoUrl,
    List<Map<String, dynamic>>? playersList,
    String? captainId,
    String? wicketkeeperId,
    int? matchesPlayed,
    int? wins,
    int? losses,
    int? tieCount,
    List? achievements,
    List? following,
    List? followers,
    int? maxPlayersCapacity,
    String? description,
    String? createdBy,
    int? rank,
    List? admins,
    int? sendRequest,
    int? pendingRequest,
    bool? isPrivate,
  }) {
    return Team(
      id: id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      logoUrl: logoUrl ?? this.logoUrl,
      playersList: playersList ?? this.playersList,
      createdBy: createdBy ?? this.createdBy,
      captainId: captainId ?? this.captainId,
      wicketkeeperId: wicketkeeperId ?? this.wicketkeeperId,
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      tieCount: tieCount ?? this.tieCount,
      achievements: achievements ?? this.achievements,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      maxPlayersCapacity: maxPlayersCapacity ?? this.maxPlayersCapacity,
      description: description ?? this.description,
      rank: rank ?? this.rank,
      sendRequest: sendRequest ?? this.sendRequest,
      pendingRequest: pendingRequest ?? this.pendingRequest,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}
