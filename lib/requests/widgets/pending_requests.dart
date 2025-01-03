import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/requests/models/request.dart';
import 'package:tracket/teams/screens/team_profile_screen.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';
import 'package:tracket/widgets/custom_widgets/my_elevated_button.dart';
import 'package:tracket/widgets/no_data_found.dart';

class PendingRequests extends StatefulWidget {
  const PendingRequests({super.key, required this.requests});

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> requests;

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
        final isPlayer = request.type == RequestType.addPlayer;

        return MyCard(
          child: Column(
            children: [
              InkWell(
                onTap: () => _navigateToProfile(context, isPlayer, request),
                child: Row(
                  children: [
                    _buildProfileImage(isPlayer, request),
                    const SizedBox(width: 10),
                    _buildRequestDetails(isPlayer, request),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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

  Widget _buildProfileImage(bool isPlayer, Request request) {
    final imageUrl = request.payload[isPlayer ? 'imageUrl' : 'logoUrl'];
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

  Widget _buildRequestDetails(bool isPlayer, Request request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          request.payload['name'] ?? 'Unknown',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          isPlayer
              ? request.payload['cricketRole'] ?? 'Unknown Role'
              : request.payload['teamName'] ?? 'Unknown Team',
          style: const TextStyle(fontSize: 15),
        ),
      ],
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
    bool isUndo = false;

    setState(() {
      requestList.removeAt(index);
    });

    showSnackBar('Request rejected', context, isUndo: true, onUndo: () {
      isUndo = true;
      setState(() {
        requestList.insert(index, requestData);
      });
    });

    await Future.delayed(const Duration(seconds: 5), () {
      if (!isUndo) {
        // FirestoreMethods.deleteRequest(request.id, context);
      }
    });
  }
}
