import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/notifications/widgets/notifications_list.dart';
import 'package:tracket/players/providers/player_provider.dart';
import 'package:tracket/teams/providers/request_status_provider.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/widgets/no_data_found.dart';

class NotificationsFetcher extends ConsumerWidget {
  const NotificationsFetcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = [];

    final player = ref.watch(playerProvider);
    final playerTeamsId = player.playerTeamsId;
    ids.addAll([...playerTeamsId, player.id]);

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection(FirestoreCollections.notification)
          .where('to', whereIn: ids)
          .get(),
      builder: (BuildContext context, snapshot) {
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

        final notifications = snapshot.data!.docs;
        ref.read(requestStatusProvider.notifier).setRequestStatus();

        return NotificationsList(notifications: notifications);
      },
    );
  }
}
