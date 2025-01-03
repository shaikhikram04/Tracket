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

  @override
  void initState() {
    requestList = widget.requests;
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
        bool isUndo = false;

        return MyCard(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  final profileScreen = isPlayer
                      ? PlayerProfileScreen(playerId: request.from)
                      : TeamProfileScreen.fromId(teamId: request.to);
                  pushScreen(context, profileScreen);
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: request
                              .payload[isPlayer ? 'imageUrl' : 'logoUrl']
                              .toString()
                              .isNotEmpty
                          ? NetworkImage(request
                              .payload[isPlayer ? 'imageUrl' : 'logoUrl'])
                          : AssetImage(isPlayer
                              ? 'assets/images/Default_user_pfp.jpg'
                              : 'assets/images/team_logo.png'),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.payload['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isPlayer
                              ? request.payload['cricketRole']
                              : request.payload['teamName'],
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyElevatedButton.primaryElevatedButton(
                    context,
                    text: 'Accept',
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  MyElevatedButton.secondaryElevatedButton(
                    context,
                    text: 'Reject',
                    onPressed: () async {
                      setState(() {
                        requestList.removeAt(index);
                      });
                      showSnackBar('Request rejected', context, isUndo: true,
                          onUndo: () {
                        isUndo = true;
                        setState(() {
                          requestList.insert(index, requestData);
                        });
                      });
                      Future.delayed(const Duration(seconds: 5), () {
                        if (!isUndo) {
                          // FirestoreMethods.deleteRequest(request.id, context);
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
