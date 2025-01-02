import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/resources/firestore_collections.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';
import 'package:tracket/widgets/custom_widgets/my_elevated_button.dart';

class RequestsListScreen extends StatelessWidget {
  const RequestsListScreen({
    super.key,
    required this.field,
    required this.playerId,
    required this.teamId,
  });

  final String field;
  final String playerId;
  final String teamId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection(FirestoreCollections.requests)
          .where(field, whereIn: [playerId, teamId]) 
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        //   return const NoDataFound(
        //     title: 'No request found',
        //     message: '',
        //     isRequest: true,
        //   );
        // }

        return ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return MyCard(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: const Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage('assets/images/Default_user_pfp.jpg'),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Player/Team Name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Request Message',
                              style: TextStyle(
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
                      MyElevatedButton.primaryElevatedButton(context,
                          text: 'Accept', onPressed: () {}),
                      const SizedBox(width: 10),
                      MyElevatedButton.secondaryElevatedButton(
                        context,
                        text: 'Reject',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
