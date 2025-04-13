import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/features/matches/models/match.dart';
import 'package:tracket/features/notifications/models/notification.dart';
import 'package:tracket/features/notifications/models/notification_result.dart';
import 'package:tracket/features/players/models/player_details.dart';
import 'package:tracket/features/players/services/players_services.dart';
import 'package:tracket/features/teams/models/team_details.dart';
import 'package:tracket/features/teams/services/teams_services.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class RequestsServices {
  static final _firestore = FirebaseFirestore.instance;

  Future<NotificationResult> offerPlayerToJoinTeam({
    required TeamDetails teamInfo,
    required PlayerDetails playerInfo,
  }) async {
    final notification = _createNotification(
      from: teamInfo.id,
      to: playerInfo.id,
      type: NotificationType.offerPlayerRequest,
      teamInfo: teamInfo,
      playerInfo: playerInfo,
    );

    try {
      await _firestore
          .collection(FirestoreCollections.notification)
          .doc(notification.notificationId)
          .set(notification.toMap);

      await TeamsServices.updateRequestedPlayers(
        playerId: playerInfo.id,
        teamId: teamInfo.id,
        isAdding: true,
      );

      return NotificationResult.successful();
    } catch (e) {
      return NotificationResult.failure(e.toString());
    }
  }

  Future<NotificationResult> joinRequestToTeam({
    required PlayerDetails playerInfo,
    required TeamDetails teamInfo,
  }) async {
    final notification = _createNotification(
      from: playerInfo.id,
      to: teamInfo.id,
      type: NotificationType.teamJoinRequest,
      teamInfo: teamInfo,
      playerInfo: playerInfo,
    );

    try {
      await _firestore
          .collection(FirestoreCollections.notification)
          .doc(notification.notificationId)
          .set(notification.toMap);

      await PlayersServices.updateRequestTeams(
        playerId: playerInfo.id,
        teamId: teamInfo.id,
        isAdding: true,
      );

      return NotificationResult.successful();
    } catch (e) {
      return NotificationResult.failure(e.toString());
    }
  }

  NotificationModel _createNotification({
    required String from,
    required String to,
    required NotificationType type,
    required TeamDetails teamInfo,
    required PlayerDetails playerInfo,
  }) {
    return NotificationModel.request(
      notificationId: uuid.v4(),
      from: from,
      to: to,
      type: type,
      createdAt: Timestamp.now(),
      status: NotificationStatus.pending,
      read: false,
      teamDetails: teamInfo,
      playerDetails: playerInfo,
    );
  }
}
