import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utils.dart';

class NotificationServices {
  static final _firestore = FirebaseFirestore.instance;

  static Future<String> deleteNotification(
    String requestId,
    BuildContext context,
  ) async {
    String result;
    try {
      await _firestore
          .collection(FirestoreCollections.notification)
          .doc(requestId)
          .delete();

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
