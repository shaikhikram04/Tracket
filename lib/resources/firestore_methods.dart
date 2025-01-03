import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/requests/models/request.dart';
import 'package:tracket/resources/firestore_collections.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/providers/team_provider.dart';
import 'package:tracket/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  static final _firestore = FirebaseFirestore.instance;
  static const uuid = Uuid();

  static Future<String> createTeam({
    required String teamName,
    required String shortName,
    required String logoUrl,
    required String createdBy,
    required String adminName,
    required String adminCricketRole,
    String adminImageUrl = '',
  }) async {
    String result;

    try {
      final team = Team(
        name: teamName,
        shortName: shortName,
        logoUrl: logoUrl,
        playersList: [],
        createdBy: createdBy,
        id: uuid.v4(),
        achievements: [],
        following: [],
        followers: [],
      );
      await _firestore
          .collection(FirestoreCollections.teams)
          .doc(team.id)
          .set(team.toJson);

      await _firestore
          .collection(FirestoreCollections.teams)
          .doc(team.id)
          .collection(FirestoreCollections.teamPlayers)
          .doc(createdBy)
          .set(
        {
          'id': createdBy,
          'name': adminName,
          'cricketRole': adminCricketRole,
          'imageUrl': adminImageUrl,
          'role': 'owner',
        },
      );

      await _firestore
          .collection(FirestoreCollections.players)
          .doc(createdBy)
          .collection(FirestoreCollections.playerTeams)
          .doc(team.id)
          .set({
        'id': team.id,
        'name': teamName,
        'shortName': shortName,
        'logoUrl': logoUrl,
        'role': 'owner',
      });

      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  static Future<Player> getPlayerFromId(String playerId) async {
    Player player;

    final fetchedData = await _firestore
        .collection(FirestoreCollections.players)
        .doc(playerId)
        .get();

    final playerTeams = await _firestore
        .collection(FirestoreCollections.players)
        .doc(playerId)
        .collection(FirestoreCollections.playerTeams)
        .get();

    player = Player.fromSeed(fetchedData.data()!, playerTeams.docs);

    return player;
  }

  static Future<void> deletePlayerFromTeam(
    String playerId,
    WidgetRef ref,
    BuildContext context,
  ) async {
    final team = ref.read(teamProvider);
    try {
      //* Update team's player list in database
      await _firestore
          .collection(FirestoreCollections.teams)
          .doc(team.id)
          .collection(FirestoreCollections.teamPlayers)
          .doc(playerId)
          .delete();
      if (team.captainId == playerId) {
        await _firestore
            .collection(FirestoreCollections.teams)
            .doc(team.id)
            .update({'captainId': ''});
        ref.read(teamProvider.notifier).updateField(captainId: '');
      }
      if (team.wicketkeeperId == playerId) {
        await _firestore
            .collection(FirestoreCollections.teams)
            .doc(team.id)
            .update({'wicketkeeperId': ''});
        ref.read(teamProvider.notifier).updateField(wicketkeeperId: '');
      }
      ref.read(teamProvider.notifier).deletePlayer(playerId);

      //* Update player's team list in database
      _firestore
          .collection(FirestoreCollections.players)
          .doc(playerId)
          .collection(FirestoreCollections.playerTeams)
          .doc(team.id)
          .delete();
      if (playerId == ref.read(playerProvider).id) {
        ref.read(playerProvider.notifier).deleteTeam(team.id);
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
            'Failed to delete player. Please try again later.', context);
      }
    }
  }

  static Future<void> addPlayerToTeam({
    required Map<String, dynamic> playerInfo,
    required Map<String, dynamic> teamInfo,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      //* Update player's team list in database
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.players)
          .doc(playerInfo['id'])
          .collection(FirestoreCollections.playerTeams)
          .doc(teamInfo['id'])
          .set(teamInfo);

      //* Update team's player list in state
      ref.read(teamProvider.notifier).addPlayer(playerInfo);

      //* Update team's player list in database
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.teams)
          .doc(teamInfo['id'])
          .collection(FirestoreCollections.teamPlayers)
          .doc(playerInfo['id'])
          .set(playerInfo);
      final currentPlayerId = ref.read(playerProvider).id;
      if (currentPlayerId == playerInfo['id']) {
        ref.read(playerProvider.notifier).addTeam(teamInfo);
      }
    } catch (error) {
      if (context.mounted) {
        showSnackBar('Failed to add player. Please try again later.', context);
      }
    }
  }

  static Future<void> updateTeamField(
    BuildContext context, {
    required String teamId,
    required String? teamName,
    required String? shortName,
    required String? description,
    required int maxPlayersCapacity,
    required String? captainId,
    required String? wicketkeeperId,
    required String? logoUrl,
  }) async {
    final Map<String, dynamic> updatedFields = {};
    if (teamName != null) updatedFields['name'] = teamName;
    if (shortName != null) updatedFields['shortName'] = shortName;
    if (description != null) updatedFields['description'] = description;
    updatedFields['maxPlayersCapacity'] = maxPlayersCapacity;
    if (captainId != null) updatedFields['captainId'] = captainId;
    if (wicketkeeperId != null) {
      updatedFields['wicketkeeperId'] = wicketkeeperId;
    }
    if (logoUrl != null) updatedFields['logoUrl'] = logoUrl;

    try {
      await _firestore
          .collection(FirestoreCollections.teams)
          .doc(teamId)
          .update(updatedFields);
    } catch (e) {
      if (context.mounted) {
        showSnackBar('Failed to update team. Please try again later.', context);
      }
    }
  }

  static Future<void> updateTeamPrivacy(
    BuildContext context, {
    required String teamId,
    required bool isPrivate,
  }) async {
    try {
      await _firestore
          .collection(FirestoreCollections.teams)
          .doc(teamId)
          .update({'isPrivate': isPrivate});
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
            'Failed to update team privacy. Please try again later.', context);
      }
    }
  }

  static Future<List<QueryDocumentSnapshot<Object?>>> getTeamPlayersFromId(
      String teamId, BuildContext context) async {
    List<QueryDocumentSnapshot<Object?>> teamPlayers = [];
    try {
      final teamPlayerSnap = await _firestore
          .collection(FirestoreCollections.teams)
          .doc(teamId)
          .collection(FirestoreCollections.teamPlayers)
          .get();

      teamPlayers = teamPlayerSnap.docs;
    } catch (e) {
      if (context.mounted) {
        showSnackBar('Unable to fetch Team data', context);
      }
    }

    return teamPlayers;
  }

  static Future<void> addAdminToTeam({
    required String playerId,
    required String teamId,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      await _firestore
          .collection(FirestoreCollections.teams)
          .doc(teamId)
          .collection(FirestoreCollections.teamPlayers)
          .doc(playerId)
          .update({'role': 'admin'});

      ref.read(teamProvider.notifier).updatePlayerRole(playerId, 'admin');
      await _firestore
          .collection(FirestoreCollections.players)
          .doc(playerId)
          .collection(FirestoreCollections.playerTeams)
          .doc(teamId)
          .update({'role': 'admin'});
      ref.read(playerProvider.notifier).updateTeamRole(teamId, 'admin');
    } catch (e) {
      if (context.mounted) {
        showSnackBar('Failed to add admin. Please try again later.', context);
      }
    }
  }

  static Future<void> requestPlayerToJoinTeam({
    required Map<String, dynamic> teamInfo,
    required Map<String, dynamic> playerInfo,
    required BuildContext context,
  }) async {
    final request = Request(
      id: uuid.v4(),
      from: teamInfo['id'],
      to: playerInfo['id'],
      type: RequestType.joinTeam,
      senderPayload: teamInfo,
      receiverPayload: playerInfo,
      requestedAt: Timestamp.now(),
    );
    try {
      await _firestore
          .collection(FirestoreCollections.requests)
          .doc(request.id)
          .set(request.toJson);
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
            'Failed to send request. Please try again later.', context);
      }
    }
  }

  static void requestTeamToAddPlayer({
    required Map<String, dynamic> playerInfo,
    required Map<String, dynamic> teamInfo,
    required BuildContext context,
  }) async {
    final request = Request(
      id: uuid.v4(),
      from: playerInfo['id'],
      to: teamInfo['id'],
      type: RequestType.addPlayer,
      senderPayload: playerInfo,
      receiverPayload: teamInfo,
      requestedAt: Timestamp.now(),
    );
    try {
      await _firestore
          .collection(FirestoreCollections.requests)
          .doc(request.id)
          .set(request.toJson);
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
            'Failed to send request. Please try again later.', context);
      }
    }
  }

  static Future<String> deleteRequest(
    String requestId,
    BuildContext context,
  ) async {
    String result;
    try {
      await _firestore
          .collection(FirestoreCollections.requests)
          .doc(requestId)
          .delete();

      result = 'success';
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
            'Failed to delete request. Please try again later.', context);
      }
      result = e.toString();
    }

    return result;
  }
}
