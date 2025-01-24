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
import 'package:tracket/widgets/no_data_found.dart';

class NotificationsList extends ConsumerStatefulWidget {
  const NotificationsList({
    super.key,
    required this.notifications,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> notifications;

  @override
  ConsumerState<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends ConsumerState<NotificationsList> {
  late final List<QueryDocumentSnapshot<Map<String, dynamic>>> notificationList;
  Map<int, Timer?> activeTimers = {}; // To track timers for each request

  @override
  void initState() {
    notificationList = widget.notifications;
    // Cancel all active timers to avoid memory leaks
    for (var timer in activeTimers.values) {
      timer?.cancel();
    }
    super.initState();
  }

  //* Check if the notification is a request from a player
  bool _isRequestFromPlayer(model.NotificationType type) {
    if (type == model.NotificationType.teamJoinRequest) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (notificationList.isEmpty) {
      return const NoDataFound(
        title: 'No notification found',
        message: '',
        isRequest: true,
      );
    }
    return ListView.builder(
      itemCount: notificationList.length,
      itemBuilder: (context, index) {
        final notificationData = notificationList[index];
        final notification =
            model.Notification.fromMap(notificationData.data());
        final isRequest =
            notification.type == model.NotificationType.teamJoinRequest ||
                notification.type == model.NotificationType.offerPlayerRequest;
        final isChallenge =
            notification.type == model.NotificationType.matchChallenge;

        final isPlayerRequest = _isRequestFromPlayer(notification.type);

        // Now data contains the updated values
        if (isRequest) {
          return RequestCard(
            request: notification,
            isSent: false,
            onCancelRequest: () {},
            onAcceptRequest: (WidgetRef ref) =>
                _acceptRequest(notification, index, isPlayerRequest, ref),
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
            onCanceChallenge: () {},
            onRejectChallenge: () =>
                _rejectNotification(context, index, notificationData),
          );
        }

        return Container();
      },
    );
  }

  void _toggleButton(String playerId, bool isAdding) {
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
    _toggleButton(challenge.notificationId, true);
    try {
      //! Acception challenge
    } finally {
      _toggleButton(challenge.notificationId, false);
    }
  }

  Future<void> _acceptRequest(
    model.Notification request,
    int index,
    bool isPlayer,
    WidgetRef ref,
  ) async {
    // Handle accept logic
    _toggleButton(request.notificationId, true);
    try {
      //* Check if the team is full before adding a player
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
          _toggleButton(request.notificationId, false);
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
        String playerId;
        String teamId;
        if (isPlayer) {
          playerId = request.from;
          teamId = request.to;
        } else {
          playerId = request.to;
          teamId = request.from;
        }
        await NotificationServices.deleteNotification(
          notificationId: request.notificationId,
          type: request.type,
          context: context,
          playerId: playerId,
          teamId: teamId,
        );
      }
    } finally {
      _toggleButton(request.notificationId, false);
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
      notificationList.removeAt(index);
    });

    bool isUndo = false;

    showSnackBar('Request rejected', context, isUndo: true, onUndo: () {
      isUndo = true;
      setState(() {
        notificationList.insert(index, notificationData);
      });
      activeTimers[index]?.cancel(); // Cancel the timer when undo is clicked
    });

    // Start a new timer for the current reject operation
    activeTimers[index] = Timer(const Duration(seconds: 5), () {
      if (!isUndo) {
        // Perform the actual deletion
        model.NotificationType type =
            model.Notification.getType(notificationData['type']);
        String? playerId;
        String teamId;
        String? challengedTeamId;
        if (type == model.NotificationType.offerPlayerRequest) {
          playerId = notificationData['to'];
          teamId = notificationData['from'];
        } else if (type == model.NotificationType.teamJoinRequest) {
          playerId = notificationData['from'];
          teamId = notificationData['to'];
        } else {
          teamId = notificationData['from'];
          challengedTeamId = notificationData['to'];
        }
        NotificationServices.deleteNotification(
          notificationId: notificationData.id,
          type: type,
          context: context,
          playerId: playerId,
          teamId: teamId,
          challengedTeamId: challengedTeamId,
        );
        activeTimers.remove(index); // Clean up the timer reference
      }
    });
  }
}
