import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/notifications/models/notification.dart';
import 'package:tracket/notifications/models/notification_result.dart';
import 'package:tracket/players/services/players_services.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class NotificationServices {
  static final _firestore = FirebaseFirestore.instance;

  Future<NotificationResult> deleteNotification({
    required String notificationId,
    required NotificationType type,
    required String? playerId,
    required String? teamId,
    required String? challengedTeamId,
  }) async {
    final batch = _firestore.batch();
    final docRef = _firestore
        .collection(FirestoreCollections.notification)
        .doc(notificationId);

    try {
      await _handleSpecificNotificationDeletion(
        type: type,
        docRef: docRef,
        batch: batch,
        playerId: playerId,
        teamId: teamId,
        challengedTeamId: challengedTeamId,
      );

      batch.delete(docRef);
      await batch.commit();

      return NotificationResult.successful();
    } catch (e) {
      return NotificationResult.failure(e.toString());
    }
  }

  Future<void> _handleSpecificNotificationDeletion({
    required NotificationType type,
    required DocumentReference docRef,
    required WriteBatch batch,
    String? playerId,
    String? teamId,
    String? challengedTeamId,
  }) async {
    switch (type) {
      case NotificationType.matchChallenge:
        await _handleMatchChallengeDeletion(
          docRef: docRef,
          batch: batch,
          teamId: teamId!,
          challengedTeamId: challengedTeamId!,
        );
        break;
      case NotificationType.offerPlayerRequest:
        await TeamsServices.updateRequestedPlayers(
          playerId: playerId!,
          teamId: teamId!,
          isAdding: false,
        );
        break;
      case NotificationType.teamJoinRequest:
        await PlayersServices.updateRequestTeams(
          playerId: playerId!,
          teamId: teamId!,
          isAdding: false,
        );
        break;

      default:
    }
  }

  Future<void> _handleMatchChallengeDeletion({
    required DocumentReference docRef,
    required WriteBatch batch,
    required String teamId,
    required String challengedTeamId,
  }) async {
    final challengerPlayersSnapshot =
        await docRef.collection(FirestoreCollections.challengerPlayers).get();

    for (final doc in challengerPlayersSnapshot.docs) {
      batch.delete(doc.reference);
    }

    await TeamsServices.updateChallengedTeams(
      teamId: teamId,
      challengedTeamId: challengedTeamId,
      isAdding: false,
    );
  }

  static Future<void> markNotificationStatus(
    String notificationId,
    NotificationStatus status,
  ) async {
    await _firestore
        .collection(FirestoreCollections.notification)
        .doc(notificationId)
        .update({'status': status.name});
  }

  
}
