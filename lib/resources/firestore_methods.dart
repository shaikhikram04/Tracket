import 'package:cloud_firestore/cloud_firestore.dart';
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
        playersList: [
          {
            'id': createdBy,
            'name': adminName,
            'cricketRole': adminCricketRole,
            'imageUrl': adminImageUrl,
          }
        ],
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
      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  static Future<Player> getPlayerFromId(String playerId) async {
    Player player;

    final fetchedData = await _firestore
        .collection(FirestoreCollections.teams)
        .doc(playerId)
        .get();
    player = Player.fromSeed(fetchedData.data()!);

    return player;
  }

  static Future<void> deletePlayerFromTeam(
    Map<String, dynamic> playerInfo,
    String teamId,
  ) async {
    await _firestore.collection(FirestoreCollections.teams).doc(teamId).update({
      'playersList': FieldValue.arrayRemove([
        {
          'id': playerInfo['id'],
          'cricketRole': playerInfo['cricketRole'],
          'imageUrl': playerInfo['imageUrl'],
          'name': playerInfo['name'],
        }
      ])
    });
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
          .collection('players')
          .doc(playerInfo['id'])
          .update({
        'teams': FieldValue.arrayUnion([
          teamInfo,
        ]),
      });
      //* Update team's player list in state
      ref.read(teamProvider.notifier).addPlayer(playerInfo);

      //* Update team's player list in database
      await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamInfo['id'])
          .update({
        'playersList': FieldValue.arrayUnion([
          playerInfo,
        ]),
      });
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
}
