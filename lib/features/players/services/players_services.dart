import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/features/teams/providers/providers.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class PlayersServices {
  static final _firestore = FirebaseFirestore.instance;

  static String _formatBowlingStyle(BowlingStyle bowlingStyle) {
    final enumString = bowlingStyle.name;
    final formattedString = enumString.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );

    return formattedString[0].toUpperCase() +
        formattedString.substring(1).toLowerCase();
  }

  static String _buildLongCricketRole({
    required Position battingPosition,
    required Position? bowlingArm,
    required BowlingStyle bowlingStyle,
  }) {
    var result = '';

    if (battingPosition == Position.righty) {
      result += 'Right-handed ';
    } else {
      result += 'Left-handed ';
    }

    result += 'Batsman';

    if (bowlingStyle != BowlingStyle.none) {
      result += ' | ';

      if (bowlingArm == Position.righty) {
        result += 'Right-arm ';
      } else if (bowlingArm == Position.lefty) {
        result += 'Left-arm ';
      }

      result += _formatBowlingStyle(bowlingStyle);
      result += ' Bowler';
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

  static Future<void> updatePlayerProfile({
    required String playerId,
    required String name,
    required String profileImageUrl,
    required CricketRole cricketRole,
    required Position battingPosition,
    required Position? bowlingArm,
    required BowlingStyle bowlingStyle,
  }) async {
    final playerDocRef =
        _firestore.collection(FirestoreCollections.players).doc(playerId);

    await playerDocRef.update({
      'playerName': name,
      'profileImageUrl': profileImageUrl,
      'playerCricketDetails.cricketRole': cricketRole.name,
      'playerCricketDetails.battingPosition': battingPosition.name,
      'playerCricketDetails.bowlingArm':
          bowlingStyle == BowlingStyle.none ? null : bowlingArm?.name,
      'playerCricketDetails.bowlingStyle': bowlingStyle.name,
    });

    final longCricketRole = _buildLongCricketRole(
      battingPosition: battingPosition,
      bowlingArm: bowlingStyle == BowlingStyle.none ? null : bowlingArm,
      bowlingStyle: bowlingStyle,
    );

    final playerTeamsSnap =
        await playerDocRef.collection(FirestoreCollections.playerTeams).get();

    if (playerTeamsSnap.docs.isEmpty) return;

    final batch = _firestore.batch();

    for (final teamDoc in playerTeamsSnap.docs) {
      final teamRosterPlayerRef = _firestore
          .collection(FirestoreCollections.teams)
          .doc(teamDoc.id)
          .collection(FirestoreCollections.teamPlayers)
          .doc(playerId);

      batch.set(
        teamRosterPlayerRef,
        {
          'name': name,
          'imageUrl': profileImageUrl,
          'cricketRole': cricketRole.name,
          'longCricketRole': longCricketRole,
        },
        SetOptions(merge: true),
      );
    }

    await batch.commit();
  }
}
