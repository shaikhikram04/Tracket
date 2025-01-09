import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/requests/models/request.dart';
import 'package:tracket/requests/services/requests_services.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/teams/providers/request_status_provider.dart';
import 'package:tracket/teams/screens/team_profile_screen.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';
import 'package:tracket/widgets/no_data_found.dart';

class PendingRequests extends StatefulWidget {
  const PendingRequests({
    super.key,
    required this.requests,
    required this.isSent,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> requests;
  final bool isSent;

  @override
  State<PendingRequests> createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
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

  Map<String, dynamic> getPayload(Request request) =>
      widget.isSent ? request.receiverPayload : request.senderPayload;

  void toggleButton(String playerId, bool isAdding, WidgetRef ref) {
    if (isAdding) {
      ref.read(requestStatusProvider.notifier).addRequestInProgress(playerId);
    } else {
      ref.read(requestStatusProvider.notifier).addRequestSuccess(playerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (requestList.isEmpty) {
      return const NoDataFound(
        title: 'No request found',
        message: '',
        isRequest: true,
      );
    }
    return ListView.builder(
      itemCount: requestList.length,
      itemBuilder: (context, index) {
        final requestData = requestList[index];
        final request = Request.fromJson(requestData.data());
        final payload = getPayload(request);
        final isPlayer = payload.containsKey('cricketRole');

        return MyCard(
          child: Column(
            children: [
              InkWell(
                onTap: () => _navigateToProfile(context, isPlayer, request),
                child: Expanded(
                  child: Row(
                    children: [
                      _buildProfileImage(isPlayer, payload),
                      const SizedBox(width: 10),
                      _buildRequestDetails(isPlayer, payload),
                      const Spacer(),
                      if (widget.isSent)
                        _buildCancelButton(context, request, index),
                    ],
                  ),
                ),
              ),
              if (!widget.isSent) const SizedBox(height: 10),
              if (!widget.isSent)
                _buildActionButtons(
                    context, index, requestData, isPlayer, request),
            ],
          ),
        );
      },
    );
  }

  void _navigateToProfile(
    BuildContext context,
    bool isPlayer,
    Request request,
  ) {
    final profileScreen = isPlayer
        ? PlayerProfileScreen(playerId: request.from)
        : TeamProfileScreen.fromId(teamId: request.to);
    pushScreen(context, profileScreen);
  }

  Widget _buildProfileImage(bool isPlayer, Map<String, dynamic> payload) {
    final imageUrl = payload[isPlayer ? 'imageUrl' : 'logoUrl'];

    return getCircleAvatar(url: imageUrl, isTeam: !isPlayer, radius: 30);
  }

  Widget _buildRequestDetails(bool isPlayer, Map<String, dynamic> payload) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            payload['name'] ?? 'Unknown',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Wrap(children: [
            Text(
              isPlayer
                  ? payload['cricketRole'] ?? 'Unknown Role'
                  : payload['shortName'] ?? 'Unknown Team',
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context, Request request, int index) {
    return Align(
      alignment: Alignment.centerRight,
      child: MyElevatedButton.secondaryElevatedButton(
        context,
        text: 'Cancel',
        onPressed: () {
          // Handle cancel logic
          showAlertDoubleBtnDialog(
            context,
            title: 'Cancel Request',
            content: 'Are you sure you want to cancel this request?',
            sureButtonText: 'Yes',
            onSureButtonPressed: () async {
              Navigator.of(context).pop();
              final result =
                  await RequestsServices.deleteRequest(request.id, context);

              if (result == 'success') {
                setState(() {
                  requestList.removeAt(index);
                });
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context,
      int index,
      QueryDocumentSnapshot<Map<String, dynamic>> requestData,
      bool isPlayer,
      Request request) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final requestStatus = ref.watch(requestStatusProvider);
        final isRequestInProgress =
            requestStatus.requestInProgress.contains(request.id);
        final isRequestSuccess =
            requestStatus.requestSuccess.contains(request.id);

        if (isRequestSuccess) {
          return Text('This request has been accept',
              style: MyTextStyle(context).bodyLarge);
        }

        return Row(
          children: [
            Text(
              timeAgo(request.requestedAt.toDate()),
              style: MyTextStyle(context).bodyMedium,
            ),
            const Spacer(),
            MyElevatedButton.primaryElevatedButton(
              context,
              text: 'Accept',
              isLoading: isRequestInProgress,
              primaryColor: const Color.fromARGB(255, 47, 134, 50),
              onPressed: () => _acceptRequest(request, index, isPlayer, ref),
            ),
            const SizedBox(width: 10),
            MyElevatedButton.secondaryElevatedButton(
              context,
              text: 'Reject',
              onPressed: () => _rejectRequest(context, index, requestData),
            ),
          ],
        );
      },
    );
  }

  String timeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays >= 356) {
      final int year = (difference.inDays / 365).floor();
      return '${year}y ago';
    } else if (difference.inDays >= 30) {
      final int month = (difference.inDays / 30).floor();
      return '${month}month ago';
    } else if (difference.inDays >= 7) {
      final int week = (difference.inDays / 7).floor();
      return '${week}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    }
    // else if (difference.inSeconds > 0) {
    //   return '${difference.inSeconds}s ago';
    // }

    return 'just now';
  }

  void _rejectRequest(BuildContext context, int index,
      QueryDocumentSnapshot<Map<String, dynamic>> requestData) async {
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
        RequestsServices.deleteRequest(requestData.id, context);
        activeTimers.remove(index); // Clean up the timer reference
      }
    });
  }

  Future<void> _acceptRequest(
      Request request, int index, bool isPlayer, WidgetRef ref) async {
    // Handle accept logic
    toggleButton(request.id, true, ref);
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
          toggleButton(request.id, false, ref);
          return;
        }
      }

      PlayerDetails playerInfo;
      TeamDetails teamInfo;

      if (request.type == RequestType.addPlayer) {
        playerInfo = PlayerDetails.fromMap(request.senderPayload);
        teamInfo = TeamDetails.formMap(request.receiverPayload);
      } else if (request.type == RequestType.joinTeam) {
        playerInfo = PlayerDetails.fromMap(request.receiverPayload);
        teamInfo = TeamDetails.formMap(request.senderPayload);
      } else {
        if (mounted) {
          showSnackBar('Request is not send properly', context);
        }
        return;
      }

      if (mounted) {
        await TeamsServices.addPlayerToTeam(
          playerInfo: playerInfo,
          teamInfo: teamInfo,
          ref: ref,
          context: context,
        );
      }

      if (mounted) {
        await RequestsServices.deleteRequest(request.id, context);
      }
    } finally {
      toggleButton(request.id, false, ref);
    }
  }
}
