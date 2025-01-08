import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/requests/models/request.dart';
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
    final request = Request(
      id: uuid.v4(),
      from: teamInfo.id,
      to: playerInfo.id,
      type: RequestType.joinTeam,
      senderPayload: teamInfo.toMap,
      receiverPayload: playerInfo.toMap,
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

  static Future<void> requestTeamToAddPlayer({
    required PlayerDetails playerInfo,
    required TeamDetails teamInfo,
    required BuildContext context,
  }) async {
    final request = Request(
      id: uuid.v4(),
      from: playerInfo.id,
      to: teamInfo.id,
      type: RequestType.addPlayer,
      senderPayload: playerInfo.toMap,
      receiverPayload: teamInfo.toMap,
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
