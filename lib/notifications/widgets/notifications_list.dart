import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/notifications/models/notification.dart' as model;
import 'package:tracket/notifications/services/notification_services.dart';
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

  void _loadData(
    model.Notification request,
    Map<String, dynamic> data,
  ) {
    if (request.type == model.NotificationType.offerPlayerRequest) {
      data['middleMessage'] = ' has offered you to join their team.';
      data['lastMessage'] = '';
      data['isPlayer'] = false;
      data['firstNameInMessage'] = request.teamDetails!.name;
      data['secondNameInMessage'] = '';
      data['imageUrl'] = request.teamDetails!.logoUrl;
    } else {
      data['middleMessage'] = ' want to join your team ';
      data['lastMessage'] = '.';
      data['isPlayer'] = true;
      data['firstNameInMessage'] = request.playerDetails!.name;
      data['secondNameInMessage'] = request.teamDetails!.name;
      data['imageUrl'] = request.playerDetails!.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: requestList.length,
      itemBuilder: (context, index) {
        final notificationData = requestList[index];
        final request = model.Notification.fromMap(notificationData.data());
        final isRequest =
            request.type == model.NotificationType.teamJoinRequest ||
                request.type == model.NotificationType.offerPlayerRequest;

        final Map<String, dynamic> requestMap = {
          'initialMessage': '',
          'middleMessage': '',
          'lastMessage': '',
          'isPlayer': false,
          'firstNameInMessage': '',
          'secondNameInMessage': '',
          'imageUrl': '',
        };
        if (isRequest) _loadData(request, requestMap);
        // Now data contains the updated values
        if (isRequest) {
          return RequestCard(
            notificationData: requestMap,
            request: request,
            isSent: false,
            onCancelRequest: () =>
                _onCancelRequest(index, request.notificationId),
            onAcceptRequest: (WidgetRef ref) => _acceptRequest(
                request, index, notificationData['isPlayer'], ref),
            onRejectRequest: () =>
                _rejectRequest(context, index, notificationData),
          );
        }

        return Container();
      },
    );
  }

  Future<void> _onCancelRequest(int index, String notificationId) async {
    Navigator.of(context).pop();
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

  void _rejectRequest(
    BuildContext context,
    int index,
    QueryDocumentSnapshot<Map<String, dynamic>> requestData,
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
        requestList.insert(index, requestData);
      });
      activeTimers[index]?.cancel(); // Cancel the timer when undo is clicked
    });

    // Start a new timer for the current reject operation
    activeTimers[index] = Timer(const Duration(seconds: 5), () {
      if (!isUndo) {
        // Perform the actual deletion
        NotificationServices.deleteNotification(requestData.id, context);
        activeTimers.remove(index); // Clean up the timer reference
      }
    });
  }
}
