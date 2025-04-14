import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/features/matches/models/ball_outcome.dart';
import 'package:tracket/features/matches/screens/operator_side_scoring_screen/current_over_indicator.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

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
          return const CircularLoadingIndicator();
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return const SizedBox.shrink();
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
