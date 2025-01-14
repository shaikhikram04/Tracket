import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/notifications/models/notification.dart' as model;
import 'package:tracket/notifications/services/requests_services.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/teams/providers/request_status_provider.dart';
import 'package:tracket/teams/screens/team_profile_screen.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';

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

  void _loadData(
    model.Notification request,
    Map<String, dynamic> data,
  ) {
    if (widget.isSent) {
      if (request.type == model.NotificationType.offerPlayerRequest) {
        data['initialMessage'] = 'Your team ';
        data['middleMessage'] = ' has offered ';
        data['lastMessage'] = ' to join.';
        data['isPlayer'] = true;
        data['firstNameInMessage'] = request.teamDetails!.name;
        data['secondNameInMessage'] = request.playerDetails!.name;
        data['imageUrl'] = request.playerDetails!.imageUrl;
      } else {
        data['middleMessage'] = 'You have requested to join the team ';
        data['lastMessage'] = '.';
        data['isPlayer'] = false;
        data['firstNameInMessage'] = '';
        data['secondNameInMessage'] = request.teamDetails!.name;
        data['imageUrl'] = request.teamDetails!.logoUrl;
      }
    } else {
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
  }

  void toggleButton(String playerId, bool isAdding, WidgetRef ref) {
    if (isAdding) {
      ref.read(requestStatusProvider.notifier).addRequestInProgress(playerId);
    } else {
      ref.read(requestStatusProvider.notifier).addRequestSuccess(playerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: requestList.length,
      itemBuilder: (context, index) {
        final requestData = requestList[index];
        final request = model.Notification.fromMap(requestData.data());

        final Map<String, dynamic> notificationData = {
          'initialMessage': '',
          'middleMessage': '',
          'lastMessage': '',
          'isPlayer': false,
          'firstNameInMessage': '',
          'secondNameInMessage': '',
          'imageUrl': '',
        };

        _loadData(request, notificationData);
// Now data contains the updated values

        return MyCard(
          child: Column(
            children: [
              InkWell(
                onTap: () => _navigateToProfile(
                    context, notificationData['isPlayer'], request),
                child: Row(
                  children: [
                    _buildProfileImage(notificationData['isPlayer'],
                        notificationData['imageUrl']),
                    const SizedBox(width: 10),
                    _buildRequestDetails(
                      firstBoldName: notificationData['firstNameInMessage'],
                      secontBoldName: notificationData['secondNameInMessage'],
                      initialMessage: notificationData['initialMessage'],
                      middleMessage: notificationData['middleMessage'],
                      lastMessage: notificationData['lastMessage'],
                    ),
                    // const Spacer(),
                    if (widget.isSent)
                      _buildCancelButton(context, request, index),
                  ],
                ),
              ),
              if (!widget.isSent)
                _buildActionButtons(context, index, requestData,
                    notificationData['isPlayer'], request),
            ],
          ),
        );
      },
    );
  }

  void _navigateToProfile(
    BuildContext context,
    bool isPlayer,
    model.Notification request,
  ) {
    final profileScreen = isPlayer
        ? PlayerProfileScreen(playerId: request.from)
        : TeamProfileScreen.fromId(teamId: request.to);
    pushScreen(context, profileScreen);
  }

  Widget _buildProfileImage(bool isPlayer, String imageUrl) {
    return getCircleAvatar(url: imageUrl, isTeam: !isPlayer, radius: 30);
  }

  Widget _buildRequestDetails({
    required String firstBoldName,
    required String secontBoldName,
    required String initialMessage,
    required String middleMessage,
    required String lastMessage,
  }) {
    return Flexible(
      child: RichText(
        text: TextSpan(
          children: [
            _buildTextSpan(initialMessage),
            _buildBoldTextSpan(firstBoldName),
            _buildTextSpan(middleMessage),
            _buildBoldTextSpan(secontBoldName),
            _buildTextSpan(lastMessage),
          ],
        ),
      ),
    );
  }

  TextSpan _buildBoldTextSpan(String text) {
    return TextSpan(
      text: text,
      style: MyTextStyle(context).boldBodyLarge,
    );
  }

  TextSpan _buildTextSpan(String text) {
    return TextSpan(
      text: text,
      style: MyTextStyle(context).bodyLarge,
    );
  }

  Widget _buildCancelButton(
      BuildContext context, model.Notification request, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 7),
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
              final result = await RequestsServices.deleteRequest(
                  request.notificationId, context);

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
      model.Notification request) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final requestStatus = ref.watch(requestStatusProvider);
          final isRequestInProgress =
              requestStatus.requestInProgress.contains(request.notificationId);
          final isRequestSuccess =
              requestStatus.requestSuccess.contains(request.notificationId);

          if (isRequestSuccess) {
            return Text('This request has been accept',
                style: MyTextStyle(context).bodyLarge);
          }

          return Row(
            children: [
              Text(
                timeAgo(request.createdAt.toDate()),
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
      ),
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

  Future<void> _acceptRequest(model.Notification request, int index,
      bool isPlayer, WidgetRef ref) async {
    // Handle accept logic
    toggleButton(request.notificationId, true, ref);
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
          toggleButton(request.notificationId, false, ref);
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
        await RequestsServices.deleteRequest(request.notificationId, context);
      }
    } finally {
      toggleButton(request.notificationId, false, ref);
    }
  }
}
