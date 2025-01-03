import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/requests/models/request.dart';
import 'package:tracket/resources/firestore_collections.dart';
import 'package:tracket/teams/screens/team_profile_screen.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';
import 'package:tracket/widgets/custom_widgets/my_elevated_button.dart';
import 'package:tracket/widgets/no_data_found.dart';

class RequestsListScreen extends ConsumerWidget {
  const RequestsListScreen({
    super.key,
    required this.field,
    this.teamId,
  });

  final String field;
  final String? teamId;

  Map<String, dynamic> teamInfo(WidgetRef ref) {
    final teamData = ref.read(playerProvider).teams!.firstWhere(
          (team) => team['id'] == teamId,
          orElse: () => {},
        );

    return teamData;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = [];
    if (teamId != null) {
      ids.add(teamId);
    } else {
      final player = ref.watch(playerProvider);
      final playerTeamsId = player.playerTeamsId;
      ids.addAll([...playerTeamsId, player.id]);
    }

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection(FirestoreCollections.requests)
          .where(field, whereIn: ids)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const NoDataFound(
            title: 'No request found',
            message: '',
            isRequest: true,
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final requestData = snapshot.data!.docs[index];
            final request = Request.fromJson(requestData.data());
            final isPlayer = request.type == RequestType.addPlayer;
            return MyCard(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      final profileScreen = isPlayer
                          ? PlayerProfileScreen(playerId: request.from)
                          : TeamProfileScreen.fromId(teamId: teamId);
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
