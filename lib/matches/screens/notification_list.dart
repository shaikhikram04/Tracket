import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/widgets/no_data_found.dart';

class NotificationListScreen extends ConsumerWidget {
  const NotificationListScreen({
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
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const NoDataFound(
            title: 'No challenge found',
            message: '',
            isRequest: true,
          );
        }

        final challenge = snapshot.data!.docs;
        return Container();
      },
    );
  }
}
