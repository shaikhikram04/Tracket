import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tracket/features/matches/models/batting_score.dart';
import 'package:tracket/features/matches/models/bowling_score.dart';
import 'package:tracket/features/matches/models/inning.dart';
import 'package:tracket/features/matches/models/match_player_info.dart';
import 'package:tracket/features/matches/widgets/match_squad.dart';
import 'package:tracket/features/matches/widgets/scoreboard_component/batting_scorecard.dart';
import 'package:tracket/features/matches/widgets/scoreboard_component/bowling_scorecard.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class InningScoreboard extends StatefulWidget {
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
  State<InningScoreboard> createState() => _InningScoreboardState();
}

class InningData {
  final Inning inning;
  final List<BattingScore> battingStats;
  final List<BowlingScore> bowlingStats;

  InningData({
    required this.inning,
    required this.battingStats,
    required this.bowlingStats,
  });
}

class _InningScoreboardState extends State<InningScoreboard> {
  late final Stream<InningData?> _combinedInningStream;

  @override
  void initState() {
    super.initState();
    _combinedInningStream = _createCombinedStream();
  }

  Stream<InningData?> _createCombinedStream() {
    final inningDocStream = FirebaseFirestore.instance
        .collection(FirestoreCollections.matches)
        .doc(widget.matchId)
        .collection(FirestoreCollections.innings)
        .doc('inning${widget.inningNumber}')
        .snapshots();

    return inningDocStream.asyncExpand((inningSnapshot) {
      if (!inningSnapshot.exists) return Stream.value(null);

      final battingStatsStream = inningSnapshot.reference
          .collection(FirestoreCollections.battingStats)
          .snapshots();

      final bowlingStatsStream = inningSnapshot.reference
          .collection(FirestoreCollections.bowlingStats)
          .snapshots();

      return Rx.combineLatest3(
        Stream.value(inningSnapshot),
        battingStatsStream,
        bowlingStatsStream,
        (DocumentSnapshot inningDoc, QuerySnapshot battingData,
            QuerySnapshot bowlingData) {
          final inning =
              Inning.fromMap(inningDoc.data()! as Map<String, dynamic>);

          final battingStats = battingData.docs
              .map((doc) =>
                  BattingScore.fromMap(doc.data()! as Map<String, dynamic>))
              .toList();

          final bowlingStats = bowlingData.docs
              .map((doc) =>
                  BowlingScore.fromMap(doc.data()! as Map<String, dynamic>))
              .toList();

          return InningData(
            inning: inning,
            battingStats: battingStats,
            bowlingStats: bowlingStats,
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InningData?>(
        stream: _combinedInningStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return MatchSquad(
              players: widget.players,
              captainId: widget.captainId,
              wicketkeeperId: widget.wicketkeeperId,
              title: '${widget.teamName} Squad',
              isLongCricketRole: true,
            );
          }

          final inningData = snapshot.data!;

          return Column(
            children: [
              BattingScorecard(
                teamName: widget.teamName,
                battingScores: inningData.battingStats,
                extras: inningData.inning.extras,
                totalScore: inningData.inning.runs,
                wickets: inningData.inning.wickets,
                overs: inningData.inning.oversDisplay,
                fallOfWickets: inningData.inning.fallOfWickets,
                allPlayers: widget.players,
              ),
              BowlingScorecard(
                bowlerStats: inningData.bowlingStats,
                isDarkMode: false,
              ),
            ],
          );
        });
  }
}
