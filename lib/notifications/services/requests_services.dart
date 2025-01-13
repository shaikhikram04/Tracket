import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/notifications/models/notification.dart' as model;
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utils.dart';

class RequestsServices {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> requestPlayerToJoinTeam({
    required TeamDetails teamInfo,
    required PlayerDetails playerInfo,
    required BuildContext context,
  }) async {
    var notification = model.Notification.request(
      notificationId: uuid.v4(),
      from: teamInfo.id,
      to: playerInfo.id,
      type: model.NotificationType.teamJoinRequest,
      createdAt: Timestamp.now(),
      status: model.NotificationStatus.pending,
      read: false,
      title: 'title',
      body: 'body',
      teamDetails: teamInfo,
      playerDetails: playerInfo,
    );

    try {
      await _firestore
          .collection(FirestoreCollections.notification)
          .doc(notification.notificationId)
          .set(notification.toMap);
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
            'Failed to send request. Please try again later.', context);
      }
    }
  }

  static Future<void> requestTeamToAddPlayer({
    required PlayerDetails playerInfo,
    required TeamDetails teamInfo,
    required BuildContext context,
  }) async {
    var notification = model.Notification.request(
      notificationId: uuid.v4(),
      from: teamInfo.id,
      to: playerInfo.id,
      type: model.NotificationType.teamJoinRequest,
      createdAt: Timestamp.now(),
      status: model.NotificationStatus.pending,
      read: false,
      title: 'title',
      body: 'body',
      teamDetails: teamInfo,
      playerDetails: playerInfo,
    );
    try {
      await _firestore
          .collection(FirestoreCollections.notification)
          .doc(notification.notificationId)
          .set(notification.toMap);
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
          .collection(FirestoreCollections.notification)
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
