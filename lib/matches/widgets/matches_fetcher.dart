import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/widgets/match_card.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/no_data_found.dart';

enum MatchesFetcherType {
  userMatches,
  completed,
  live,
  upcoming,
}

class MatchesFetcher extends StatelessWidget {
  const MatchesFetcher({
    super.key,
    required this.type,
    this.userId,
    this.userTeamIds,
  });

  final MatchesFetcherType type;
  final List<String>? userTeamIds;
  final String? userId;

  String collectionPath() {
    switch (type) {
      case MatchesFetcherType.live:
        return MatchStatus.live.name;
      case MatchesFetcherType.upcoming:
        return MatchStatus.scheduled.name;
      case MatchesFetcherType.completed:
        return MatchStatus.completed.name;
      case MatchesFetcherType.userMatches:
        return '';
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _stream() {
    switch (type) {
      case MatchesFetcherType.userMatches:
        return FirebaseFirestore.instance
            .collection(FirestoreCollections.matches)
            .where('participants', arrayContainsAny: userTeamIds)
            .snapshots();
      default:
        return FirebaseFirestore.instance
            .collection(FirestoreCollections.matches)
            .where('status', isEqualTo: collectionPath())
            .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return getCircleLoadingIndicator();
        }
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const NoDataFound(
            title: 'No matches found',
            message: 'Wait for a match to start',
          );
        }

        final matches = snapshot.data!.docs;
        return ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return MatchCard(
              match: Match.fromMap(match.data()),
            );
          },
        );
      },
    );
  }
}
