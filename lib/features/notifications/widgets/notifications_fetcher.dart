import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/notifications/widgets/notifications_list.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/app_icon_data.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/common/widgets/no_data_found.dart';

class NotificationsFetcher extends ConsumerWidget {
  const NotificationsFetcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = [];
    // ref.read(requestStatusProvider.notifier).setRequestStatus();

    final player = ref.watch(playerProvider);
    final playerTeamsId = player.playerTeamsId;
    ids.addAll([...playerTeamsId, player.id]);

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection(FirestoreCollections.notification)
          .where('to', whereIn: ids)
          .where('status', isEqualTo: 'pending')
          .get(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return THelperFunction.getCircleLoadingIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const NoDataFound(
            title: 'No Notification found',
            message: '',
            iconData: AppIconData.notificationOff,
          );
        }

        final notifications = snapshot.data!.docs;

        return NotificationsList(notifications: notifications);
      },
    );
  }
}
