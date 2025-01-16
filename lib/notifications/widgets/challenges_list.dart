import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/notifications/models/notification.dart' as model;
import 'package:tracket/notifications/services/notification_services.dart';
import 'package:tracket/notifications/widgets/challenge_card.dart';
import 'package:tracket/teams/providers/request_status_provider.dart';
import 'package:tracket/utils/utils.dart';

class ChallengesList extends StatefulWidget {
  const ChallengesList({
    super.key,
    required this.challenge,
    required this.isSent,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> challenge;
  final bool isSent;

  @override
  State<ChallengesList> createState() => _ChallengesListState();
}

class _ChallengesListState extends State<ChallengesList> {
  late final List<QueryDocumentSnapshot<Map<String, dynamic>>> requestList;
  Map<int, Timer?> activeTimers = {}; // To track timers for each request

  @override
  void initState() {
    requestList = widget.challenge;
    // Cancel all active timers to avoid memory leaks
    for (var timer in activeTimers.values) {
      timer?.cancel();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: requestList.length,
      itemBuilder: (context, index) {
        final challengeData = requestList[index];
        final challenge = model.Notification.fromMap(challengeData.data());

        // Now data contains the updated values

        return ChallengeCard(
          challenge: challenge,
          isSent: widget.isSent,
          onAcceptChallenge: (ref) => _acceptChallenge(challenge, index, ref),
          onCanceChallenge: () =>
              _onCancelChallenge(index, challenge.notificationId),
          onRejectChallenge: () =>
              _rejectChallenge(context, index, challengeData),
        );
      },
    );
  }

  Future<void> _onCancelChallenge(int index, String notificationId) async {
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

  void _rejectChallenge(
    BuildContext context,
    int index,
    QueryDocumentSnapshot<Map<String, dynamic>> challengeData,
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
        requestList.insert(index, challengeData);
      });
      activeTimers[index]?.cancel(); // Cancel the timer when undo is clicked
    });

    // Start a new timer for the current reject operation
    activeTimers[index] = Timer(const Duration(seconds: 5), () {
      if (!isUndo) {
        // Perform the actual deletion
        NotificationServices.deleteNotification(challengeData.id, context);
        activeTimers.remove(index); // Clean up the timer reference
      }
    });
  }
}
