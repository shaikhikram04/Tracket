import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/notifications/models/notification.dart' ;
import 'package:tracket/notifications/services/notification_services.dart';
import 'package:tracket/notifications/widgets/request_card.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/teams/providers/request_status_provider.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/no_data_found.dart';

class RequestList extends ConsumerStatefulWidget {
  const RequestList({
    super.key,
    required this.requests,
    required this.isSent,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> requests;
  final bool isSent;

  @override
  ConsumerState<RequestList> createState() => _RequestListState();
}

class _RequestListState extends ConsumerState<RequestList> {
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

  //* Check if the request is for a player or a team
  bool _isPlayer(NotificationType type) {
    if (widget.isSent && type == NotificationType.offerPlayerRequest) {
      return true;
    }
    if (!widget.isSent && type == NotificationType.teamJoinRequest) {
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
        final request = NotificationModel.fromMap(requestData.data());

        final isPlayer = _isPlayer(request.type);

        return RequestCard(
          request: request,
          isSent: widget.isSent,
          onCancelRequest: () => _onCancelRequest(
            index: index,
            notificationId: request.notificationId,
            type: request.type,
            playerId: request.playerDetails!.id,
            teamId: request.teamDetails!.id,
          ),
          onAcceptRequest: (WidgetRef ref) =>
              _acceptRequest(request, index, isPlayer, ref),
          onRejectRequest: () => _rejectRequest(
            context,
            index: index,
            requestData: requestData,
            type: request.type,
          ),
        );
      },
    );
  }

  Future<void> _onCancelRequest(
      {required int index,
      required String notificationId,
      required NotificationType type,
      required String playerId,
      required String teamId}) async {
    final result = await NotificationServices().deleteNotification(
      notificationId: notificationId,
      type: type,
      playerId: playerId,
      teamId: teamId,
      challengedTeamId: null,
    );

    if (result.success) {
      if (type == NotificationType.teamJoinRequest) {
        ref.read(playerProvider.notifier).updateRequestedTeam(teamId, false);
      }
      setState(() {
        requestList.removeAt(index);
      });
    } else {
      showSnackBar(result.error!, context);
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
    NotificationModel request,
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
        String playerId;
        String teamId;
        if (request.type == NotificationType.offerPlayerRequest) {
          playerId = request.to;
          teamId = request.from;
        } else {
          playerId = request.from;
          teamId = request.to;
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

  void _rejectRequest(
    BuildContext context, {
    required int index,
    required QueryDocumentSnapshot<Map<String, dynamic>> requestData,
    required NotificationType type,
  }) async {
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
    activeTimers[index] = Timer(const Duration(seconds: 5), () async {
      if (!isUndo) {
        String playerId;
        String teamId;
        if (type == NotificationType.offerPlayerRequest) {
          playerId = requestData['to'];
          teamId = requestData['from'];
        } else {
          playerId = requestData['from'];
          teamId = requestData['to'];
          ref.read(playerProvider.notifier).updateRequestedTeam(teamId, false);
        }
        final result = await NotificationServices().deleteNotification(
          notificationId: requestData.id,
          type: type,
          playerId: playerId,
          teamId: teamId,
          challengedTeamId: null,
        );
        if (!result.success) {
          showSnackBar(result.error!, context);
        }
        activeTimers.remove(index); // Clean up the timer reference
      }
    });
  }
}
