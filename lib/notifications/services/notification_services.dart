import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/notifications/models/notification.dart';
import 'package:tracket/players/services/players_services.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utils.dart';

class NotificationServices {
  static final _firestore = FirebaseFirestore.instance;

  static Future<String> deleteNotification({
    required String notificationId,
    required NotificationType type,
    required BuildContext context,
    String? playerId,
    String? teamId,
    String? challengedTeamId,
  }) async {
    final batch = _firestore.batch();
    final docRef = _firestore
        .collection(FirestoreCollections.notification)
        .doc(notificationId);

    String result;
    try {
      if (type == NotificationType.matchChallenge) {
        final challengerPlayersSnapshot = await docRef
            .collection(FirestoreCollections.challengerPlayers)
            .get();
        for (final doc in challengerPlayersSnapshot.docs) {
          batch.delete(doc.reference);
        }

        TeamsServices.updateChallengedTeams(
          teamId: teamId!,
          challengedTeamId: challengedTeamId!,
          isAdding: false,
        );
      } else if (type == NotificationType.offerPlayerRequest) {
        await TeamsServices.updateRequestedPlayers(
          playerId: playerId!,
          teamId: teamId!,
          isAdding: false,
        );
      } else if (type == NotificationType.teamJoinRequest) {
        await PlayersServices.updateRequestTeams(
          playerId: playerId!,
          teamId: teamId!,
          isAdding: false,
        );
      }

      // Delete the main document
      batch.delete(docRef);

      // Commit the batch
      await batch.commit();

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
