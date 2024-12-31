import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/providers/player_provider.dart';
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
    required String? logoUrl,
    required String createdBy,
    required String adminName,
    required String adminCricketRole,
    String? adminImageUrl,
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
    String teamId,
    WidgetRef ref,
    BuildContext context,
  ) async {
    try {
      //* Update team's player list in database
      await _firestore
          .collection(FirestoreCollections.teams)
          .doc(teamId)
          .collection(FirestoreCollections.teamPlayers)
          .doc(playerId)
          .delete();

      ref.read(teamProvider.notifier).deletePlayer(playerId);

      //* Update player's team list in database
      _firestore
          .collection(FirestoreCollections.players)
          .doc(playerId)
          .collection(FirestoreCollections.playerTeams)
          .doc(teamId)
          .delete();

      ref.read(playerProvider.notifier).deleteTeam(teamId);
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

  static Future<void> updateTeamField({
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
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<void> updateTeamPrivacy({
    required String teamId,
    required bool isPrivate,
  }) async {
    try {
      await _firestore
          .collection(FirestoreCollections.teams)
          .doc(teamId)
          .update({'isPrivate': isPrivate});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<List<QueryDocumentSnapshot<Object?>>> getTeamPlayersFromId(
      String teamId) async {
    final teamPlayerSnap = await _firestore
        .collection(FirestoreCollections.teams)
        .doc(teamId)
        .collection(FirestoreCollections.teamPlayers)
        .get();

    return teamPlayerSnap.docs;
  }

  static void addAdminToTeam({
    required String playerId,
    required String teamId,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {} catch (e) {
      if (context.mounted) {
        showSnackBar('Failed to add admin. Please try again later.', context);
      }
    }
  }
}
