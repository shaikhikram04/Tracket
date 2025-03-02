import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/notifications/widgets/challenges_list.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/no_data_found.dart';

class ChallengesFetcher extends ConsumerWidget {
  const ChallengesFetcher({
    super.key,
    required this.field,
    this.teamId,
  });

  final String field;
  final String? teamId;

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
          .collection(FirestoreCollections.notification)
          .where(field, whereIn: ids)
          .where('type', whereIn: ['matchChallenge'])
          .where('status', isEqualTo: 'pending')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return getCircleLoadingIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const NoDataFound(
            title: 'No Challenge found',
            message: '',
            iconData: AppIconData.noificationOff,
          );
        }

        final challenges = snapshot.data!.docs;
        // ref.read(requestStatusProvider.notifier).setRequestStatus();
        return ChallengesList(challenge: challenges, isSent: field == 'from');
      },
    );
  }
}
