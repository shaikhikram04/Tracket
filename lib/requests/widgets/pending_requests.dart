import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/requests/models/request.dart';
import 'package:tracket/resources/firestore_methods.dart';
import 'package:tracket/teams/screens/team_profile_screen.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';
import 'package:tracket/widgets/custom_widgets/my_elevated_button.dart';
import 'package:tracket/widgets/no_data_found.dart';

class PendingRequests extends StatefulWidget {
  const PendingRequests(
      {super.key, required this.requests, required this.isSent});

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

  @override
  Widget build(BuildContext context) {
    if (requestList.isEmpty) {
      return const NoDataFound(
        title: 'No request found',
        message: '' ,
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
              if (!widget.isSent) const SizedBox(height: 10),
              if (!widget.isSent)
                _buildActionButtons(context, index, requestData, request),
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
    final defaultImage = isPlayer
        ? 'assets/images/Default_user_pfp.jpg'
        : 'assets/images/team_logo.png';

    return CircleAvatar(
      radius: 30,
      backgroundImage: imageUrl?.isNotEmpty == true
          ? NetworkImage(imageUrl)
          : AssetImage(defaultImage) as ImageProvider,
    );
  }

  Widget _buildRequestDetails(bool isPlayer, Map<String, dynamic> payload) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          payload['name'] ?? 'Unknown',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          isPlayer
              ? payload['cricketRole'] ?? 'Unknown Role'
              : payload['shortName'] ?? 'Unknown Team',
          style: const TextStyle(fontSize: 15),
        ),
      ],
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
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Cancel Request'),
                backgroundColor: Colors.white,
                content:
                    const Text('Are you sure you want to cancel this request?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final result = await FirestoreMethods.deleteRequest(
                          request.id, context);

                      if (result == 'success') {
                        setState(() {
                          requestList.removeAt(index);
                        });
                      }
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
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
      Request request) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MyElevatedButton.primaryElevatedButton(
          context,
          text: 'Accept',
          onPressed: () {
            // Handle accept logic
          },
        ),
        const SizedBox(width: 10),
        MyElevatedButton.secondaryElevatedButton(
          context,
          text: 'Reject',
          onPressed: () => _rejectRequest(context, index, requestData),
        ),
      ],
    );
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
        FirestoreMethods.deleteRequest(requestData.id, context);
        activeTimers.remove(index); // Clean up the timer reference
      }
    });
  }
}
