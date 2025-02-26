import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/widgets/match_squad.dart';
import 'package:tracket/matches/widgets/scoreboard_component/batting_scorecard.dart';
import 'package:tracket/matches/widgets/scoreboard_component/bowling_scorecard.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class InningScoreboard extends StatelessWidget {
  const InningScoreboard({
    super.key,
    required this.matchId,
    required this.inningNumber,
    required this.teamName,
    required this.captainId,
    required this.wicketkeeperId,
    required this.players,
  });

  final String teamName;
  final String captainId;
  final String wicketkeeperId;
  final List<MatchPlayerInfo> players;
  final String matchId;
  final int inningNumber;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.matches)
            .doc(matchId)
            .collection(FirestoreCollections.innings)
            .doc('inning$inningNumber')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return MatchSquad(
              players: players,
              captainId: captainId,
              wicketkeeperId: wicketkeeperId,
              title: '${teamName} Squad',
              isLongCricketRole: true,
            );
          }

          final inningData = snapshot.data!.data();
          final inning = Inning.fromMap(inningData!);

          return Column(
            children: [
              BattingScorecard(
                teamName: teamName,
                battingScores: inning.battingStats,
                extras: inning.extras,
                totalScore: inning.runs,
                wickets: inning.wickets,
                overs: inning.oversDisplay,
                fallOfWickets: inning.fallOfWickets,
              ),
              BowlingScorecard(
                  bowlerStats: inning.bowlingStats, isDarkMode: false),
            ],
          );
        });
  }
}
