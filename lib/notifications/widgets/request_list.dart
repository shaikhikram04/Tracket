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
import 'package:tracket/widgets/no_data_found.dart';

class RequestList extends StatefulWidget {
  const RequestList({
    super.key,
    required this.requests,
    required this.isSent,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> requests;
  final bool isSent;

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  late final List<QueryDocumentSnapshot<Map<String, dynamic>>> requestList;
  Map<int, Timer?> activeTimers = {}; // To track timers for each request

  @override
  void initState() {
    requestList = widget.requests;
    // Cancel all active timers to avoid memory leaks
    for (var timer in activeTimers.values) {
      timer?.cancel();
    }
    super.initState();
  }

  bool _isPlayer(model.NotificationType type) {
    if (widget.isSent && type == model.NotificationType.offerPlayerRequest) {
      return true;
    }
    if (!widget.isSent && type == model.NotificationType.teamJoinRequest) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (requestList.isEmpty) {
      return const NoDataFound(
        title: 'No Request Found',
        message: '',
        isRequest: true,
      );
    }
    return ListView.builder(
      itemCount: requestList.length,
      itemBuilder: (context, index) {
        final requestData = requestList[index];
        final request = model.Notification.fromMap(requestData.data());

        final isPlayer = _isPlayer(request.type);

        return RequestCard(
          request: request,
          isSent: widget.isSent,
          onCancelRequest: () =>
              _onCancelRequest(index, request.notificationId),
          onAcceptRequest: (WidgetRef ref) =>
              _acceptRequest(request, index, isPlayer, ref),
          onRejectRequest: () => _rejectRequest(context, index, requestData),
        );
      },
    );
  }

  Future<void> _onCancelRequest(int index, String notificationId) async {
    final result = await NotificationServices.deleteNotification(
      notificationId,
      context,
    );

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
