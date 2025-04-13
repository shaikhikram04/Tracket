import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/notifications/models/notification.dart';
import 'package:tracket/features/notifications/services/notification_services.dart';
import 'package:tracket/features/notifications/widgets/challenge_card.dart';
import 'package:tracket/features/notifications/widgets/request_card.dart';
import 'package:tracket/features/teams/providers/providers.dart';
import 'package:tracket/features/teams/services/teams_services.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/common/widgets/no_data_found.dart';

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
  bool _isRequestFromPlayer(NotificationType type) {
    if (type == NotificationType.teamJoinRequest) {
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
        iconData: AppIconData.noificationOff
      );
    }
    return ListView.builder(
      itemCount: notificationList.length,
      itemBuilder: (context, index) {
        final notificationData = notificationList[index];
        final notification = NotificationModel.fromMap(notificationData.data());
        final isRequest =
            notification.type == NotificationType.teamJoinRequest ||
                notification.type == NotificationType.offerPlayerRequest;
        final isChallenge =
            notification.type == NotificationType.matchChallenge;

        final isPlayerRequest = _isRequestFromPlayer(notification.type);

        // Now data contains the updated values
        if (isRequest) {
          return RequestCard(
            request: notification,
            isSent: false,
            onCancelRequest: () {},
            onAcceptRequest: (WidgetRef ref) =>
                _acceptRequest(notification, index, isPlayerRequest, ref),
            onRejectRequest: () => _rejectNotification(
              context,
              index: index,
              notificationData: notificationData,
              notificationType: notification.type,
            ),
          );
        }
        if (isChallenge) {
          return ChallengeCard(
            challenge: notification,
            isSent: false,
            onCanceChallenge: () {},
            onRejectChallenge: () => _rejectNotification(
              context,
              index: index,
              notificationData: notificationData,
              notificationType: notification.type,
            ),
            onAccepted: () => _onChallengeAccepted(index),
          );
        }

        return Container();
      },
    );
  }

  void _toggleButton(String playerId, bool isAdding, WidgetRef ref) {
    if (isAdding) {
      ref.read(requestProvider.notifier).addRequestInProgress(playerId);
    } else {
      ref.read(requestProvider.notifier).markRequestSuccess(playerId);
    }
  }

  Future<void> _acceptRequest(
    NotificationModel request,
    int index,
    bool isPlayer,
    WidgetRef ref,
  ) async {
    // Handle accept logic
    _toggleButton(request.notificationId, true, ref);
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
        String playerId;
        String teamId;
        if (isPlayer) {
          playerId = request.from;
          teamId = request.to;
        } else {
          playerId = request.to;
          teamId = request.from;
        }
        final result = await NotificationServices().deleteNotification(
          notificationId: request.notificationId,
          type: request.type,
          playerId: playerId,
          teamId: teamId,
          challengedTeamId: null,
        );
        if (!result.success) {
          showSnackBar(result.error!, context);
        }
      }
    } finally {
      _toggleButton(request.notificationId, false, ref);
    }
  }

  void _rejectNotification(
    BuildContext context, {
    required int index,
    required QueryDocumentSnapshot<Map<String, dynamic>> notificationData,
    required NotificationType notificationType,
  }) async {
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
    activeTimers[index] = Timer(const Duration(seconds: 5), () async {
      if (!isUndo) {
        String? playerId;
        String teamId;
        String? challengedTeamId;
        if (notificationType == NotificationType.offerPlayerRequest) {
          playerId = notificationData['to'];
          teamId = notificationData['from'];
        } else if (notificationType == NotificationType.teamJoinRequest) {
          playerId = notificationData['from'];
          teamId = notificationData['to'];
        } else {
          teamId = notificationData['from'];
          challengedTeamId = notificationData['to'];
        }
        final result = await NotificationServices().deleteNotification(
          notificationId: notificationData.id,
          type: notificationType,
          playerId: playerId,
          teamId: teamId,
          challengedTeamId: challengedTeamId,
        );
        if (!result.success) {
          showSnackBar(result.error!, context);
        }
        activeTimers.remove(index); // Clean up the timer reference
      }
    });
  }

  void _onChallengeAccepted(int index) {
    // Remove the request from the list and show the undo snack bar
    setState(() {
      notificationList.removeAt(index);
    });
  }
}
