import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/matches/models/ball_outcome.dart';
import 'package:tracket/matches/screens/operator_side_scoring_screen/current_over_indicator.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:tracket/utils/utils.dart';

class CurrentOverFetcher extends StatelessWidget {
  const CurrentOverFetcher({
    super.key,
    required this.matchId,
  });

  final String matchId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(FirestoreCollections.matches)
          .doc(matchId)
          .collection(FirestoreCollections.balls)
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return getCircleLoadingIndicator();
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return SizedBox.shrink();
        }

        final currOverRuns = snapshot.data!.docs;
        int remainingBalls;
        if (currOverRuns.isEmpty) {
          remainingBalls = 6;
        } else {
          remainingBalls = 6 - currOverRuns.last.data()['ballNumber'] as int;
        }

        final balls = BallOutcome.fromQuerySnapshot(currOverRuns);

        return CurrentOverIndicator(
          balls: balls,
          isBlur: false,
          remainingBalls: remainingBalls,
          showShadow: false,
          bgColor: LightThemeColors.surfaceColor.withValues(alpha: 0.9),
        );
      },
    );
  }
}
