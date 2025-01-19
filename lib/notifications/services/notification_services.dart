import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utils.dart';

class NotificationServices {
  static final _firestore = FirebaseFirestore.instance;

  static Future<String> deleteNotification(
    String notificationId,
    BuildContext context,
  ) async {
    final batch = _firestore.batch();
    final docRef = _firestore
        .collection(FirestoreCollections.notification)
        .doc(notificationId);

    String result;
    try {
      final challengerPlayersSnapshot =
          await docRef.collection(FirestoreCollections.challengerPlayers).get();
      for (final doc in challengerPlayersSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete the main document
      batch.delete(docRef);

      // Commit the batch
      await batch.commit();

      result = 'success';
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
            'Failed to delete request. Please try again later.', context);
      }
      result = e.toString();
    }

    return result;
  }
}
