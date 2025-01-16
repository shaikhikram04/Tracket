import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/notifications/models/notification.dart' as model;
import 'package:tracket/notifications/services/notification_services.dart';
import 'package:tracket/notifications/widgets/challenge_card.dart';
import 'package:tracket/notifications/widgets/request_card.dart';
import 'package:tracket/teams/providers/request_status_provider.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utils.dart';

class NotificationsList extends StatefulWidget {
  const NotificationsList({
    super.key,
    required this.notifications,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> notifications;

  @override
  State<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  late final List<QueryDocumentSnapshot<Map<String, dynamic>>> requestList;
  Map<int, Timer?> activeTimers = {}; // To track timers for each request

  @override
  void initState() {
    requestList = widget.notifications;
    // Cancel all active timers to avoid memory leaks
    for (var timer in activeTimers.values) {
      timer?.cancel();
    }
    super.initState();
  }

  bool _isPlayer(model.NotificationType type) {
    if (type == model.NotificationType.teamJoinRequest) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: requestList.length,
      itemBuilder: (context, index) {
        final notificationData = requestList[index];
        final notification =
            model.Notification.fromMap(notificationData.data());
        final isRequest =
            notification.type == model.NotificationType.teamJoinRequest ||
                notification.type == model.NotificationType.offerPlayerRequest;
        final isChallenge =
            notification.type == model.NotificationType.matchChallenge;

        final isPlayer = _isPlayer(notification.type);

        // Now data contains the updated values
        if (isRequest) {
          return RequestCard(
            request: notification,
            isSent: false,
            onCancelRequest: () =>
                _cancelNotification(index, notification.notificationId),
            onAcceptRequest: (WidgetRef ref) =>
                _acceptRequest(notification, index, isPlayer, ref),
            onRejectRequest: () =>
                _rejectNotification(context, index, notificationData),
          );
        }
        if (isChallenge) {
          return ChallengeCard(
            challenge: notification,
            isSent: false,
            onAcceptChallenge: (ref) =>
                _acceptChallenge(notification, index, ref),
            onCanceChallenge: () =>
                _cancelNotification(index, notification.notificationId),
            onRejectChallenge: () =>
                _rejectNotification(context, index, notificationData),
          );
        }

        return Container();
      },
    );
  }

  Future<void> _cancelNotification(int index, String notificationId) async {
    final result =
        await NotificationServices.deleteNotification(notificationId, context);

    if (result == 'success') {
      setState(() {
        requestList.removeAt(index);
      });
    }
  }

  void _toggleButton(String playerId, bool isAdding, WidgetRef ref) {
    if (isAdding) {
      ref.read(requestStatusProvider.notifier).addRequestInProgress(playerId);
    } else {
      ref.read(requestStatusProvider.notifier).addRequestSuccess(playerId);
    }
  }

  Future<void> _acceptChallenge(
    model.Notification challenge,
    int index,
    WidgetRef ref,
  ) async {
    // Handle accept logic
    _toggleButton(challenge.notificationId, true, ref);
    try {
      //! Acception challenge
    } finally {
      _toggleButton(challenge.notificationId, false, ref);
    }
  }

  Future<void> _acceptRequest(
    model.Notification request,
    int index,
    bool isPlayer,
    WidgetRef ref,
  ) async {
    // Handle accept logic
    _toggleButton(request.notificationId, true, ref);
    try {
      if (!isPlayer) {
        final teamDocRef = FirebaseFirestore.instance
            .collection(FirestoreCollections.teams)
            .doc(request.to);

        final teamPlayers =
            await teamDocRef.collection(FirestoreCollections.teamPlayers).get();

        final teamData = await teamDocRef.get();

        final teamLimit = teamData.data()!['maxPlayersCapacity'];
        final currentPlayers = teamPlayers.docs.length;

        if (currentPlayers >= teamLimit && mounted) {
          showSnackBar('Team is full', context);
          _toggleButton(request.notificationId, false, ref);
          return;
        }
      }

      if (mounted) {
        await TeamsServices.addPlayerToTeam(
          playerInfo: request.playerDetails!,
          teamInfo: request.teamDetails!,
          ref: ref,
          context: context,
        );
      }

      if (mounted) {
        await NotificationServices.deleteNotification(
            request.notificationId, context);
      }
    } finally {
      _toggleButton(request.notificationId, false, ref);
    }
  }

  void _rejectNotification(
    BuildContext context,
    int index,
    QueryDocumentSnapshot<Map<String, dynamic>> notificationData,
  ) async {
    // Cancel any existing timer for this index
    activeTimers[index]?.cancel();

    // Remove the request from the list and show the undo snack bar
    setState(() {
      requestList.removeAt(index);
    });

    bool isUndo = false;

    showSnackBar('Request rejected', context, isUndo: true, onUndo: () {
      isUndo = true;
      setState(() {
        requestList.insert(index, notificationData);
      });
      activeTimers[index]?.cancel(); // Cancel the timer when undo is clicked
    });

    // Start a new timer for the current reject operation
    activeTimers[index] = Timer(const Duration(seconds: 5), () {
      if (!isUndo) {
        // Perform the actual deletion
        NotificationServices.deleteNotification(notificationData.id, context);
        activeTimers.remove(index); // Clean up the timer reference
      }
    });
  }
}
