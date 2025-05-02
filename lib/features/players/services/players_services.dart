import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/features/teams/models/team_role.dart';
import 'package:tracket/features/teams/providers/providers.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class PlayersServices {
  static final _firestore = FirebaseFirestore.instance;

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

    final allFormatStatsSnap = await _firestore
        .collection(FirestoreCollections.players)
        .doc(playerId)
        .collection(FirestoreCollections.stats)
        .get();

    final allFormatStatsDoc = allFormatStatsSnap.docs;
    final allFormatStats = <String, dynamic>{};
    for (final stats in allFormatStatsDoc) {
      allFormatStats.addAll({stats.id: stats.data()});
    }

    player =
        Player.fromSeed(fetchedData.data()!, playerTeams.docs, allFormatStats);

    return player;
  }

  static Future<void> changePlayerTeamRole({
    required String playerId,
    required String teamId,
    required TeamRole newRole,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      await _firestore
          .collection(FirestoreCollections.teams)
          .doc(teamId)
          .collection(FirestoreCollections.teamPlayers)
          .doc(playerId)
          .update({'role': newRole.name});
      ref.read(teamProvider.notifier).updatePlayerRole(playerId, newRole);

      await _firestore
          .collection(FirestoreCollections.players)
          .doc(playerId)
          .collection(FirestoreCollections.playerTeams)
          .doc(teamId)
          .update({'role': newRole.name});
      ref.read(playerProvider.notifier).updateTeamRole(teamId, newRole);
    } catch (e) {
      if (context.mounted) {
        THelperFunction.showSnackBar(
            'Failed to add admin. Please try again later.', context);
      }
    }
  }

  static Future<void> updateRequestTeams({
    required String playerId,
    required String teamId,
    required bool isAdding,
  }) async {
    await _firestore
        .collection(FirestoreCollections.players)
        .doc(playerId)
        .update({
      'requestedTeam': isAdding
          ? FieldValue.arrayUnion([teamId])
          : FieldValue.arrayRemove([teamId])
    });
  }
}
