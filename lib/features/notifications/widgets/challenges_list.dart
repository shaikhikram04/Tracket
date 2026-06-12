import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/no_data_found.dart';
import 'package:tracket/features/notifications/models/notification.dart';
import 'package:tracket/features/notifications/services/notification_services.dart';
import 'package:tracket/features/notifications/widgets/challenge_card.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';

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
  late final List<QueryDocumentSnapshot<Map<String, dynamic>>> challengeList;
  Map<int, Timer?> activeTimers = {}; // To track timers for each request

  @override
  void initState() {
    challengeList = widget.challenge;
    // Cancel all active timers to avoid memory leaks
    for (var timer in activeTimers.values) {
      timer?.cancel();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (challengeList.isEmpty) {
      return const NoDataFound(
        title: 'No Challenge Found',
        message: '',
        iconData: AppIconData.notificationOff,
      );
    }
    return ListView.builder(
      itemCount: challengeList.length,
      itemBuilder: (context, index) {
        final challengeData = challengeList[index];
        final challenge = NotificationModel.fromMap(challengeData.data());

        return ChallengeCard(
          challenge: challenge,
          isSent: widget.isSent,
          onCancelChallenge: () => _cancelChallenge(
            index: index,
            notificationId: challenge.notificationId,
            challengerTeamId: challengeData['from'],
            challengedTeamId: challengeData['to'],
          ),
          onRejectChallenge: () => _rejectChallenge(context, index, challengeData),
          onAccepted: () => _onAccepted(index),
        );
      },
    );
  }

  Future<void> _cancelChallenge({
    required int index,
    required String notificationId,
    required String challengerTeamId,
    required String challengedTeamId,
  }) async {
    final result = await NotificationServices().deleteNotification(
      notificationId: notificationId,
      type: NotificationType.matchChallenge,
      teamId: challengerTeamId,
      challengedTeamId: challengedTeamId,
      playerId: null,
    );

    if (result.success) {
      setState(() {
        challengeList.removeAt(index);
      });
    } else if (mounted) {
      THelperFunction.showSnackBar('Failed to cancel challenge! : ${result.error}', context);
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
      challengeList.removeAt(index);
    });

    bool isUndo = false;

    THelperFunction.showSnackBar('Challenge rejected', context, isUndo: true, onUndo: () {
      isUndo = true;
      setState(() {
        challengeList.insert(index, challengeData);
      });
      activeTimers[index]?.cancel(); // Cancel the timer when undo is clicked
    });

    // Start a new timer for the current reject operation
    activeTimers[index] = Timer(const Duration(seconds: 5), () async {
      if (!isUndo) {
        // Perform the actual deletion
        try {
          await NotificationServices.markNotificationStatus(
            challengeData.id,
            NotificationStatus.reject,
          );
          activeTimers.remove(index); // Clean up the timer reference
        } catch (e) {
          if (context.mounted) {
            THelperFunction.showSnackBar('Failed to reject challenge : $e', context);
          }
        }
      }
    });
  }

  void _onAccepted(int index) {
    setState(() {
      challengeList.removeAt(index);
    });
  }
}
