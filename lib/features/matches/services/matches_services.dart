import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/features/matches/models/ball_outcome.dart';
import 'package:tracket/features/matches/models/batting_score.dart';
import 'package:tracket/features/matches/models/bowling_score.dart';
import 'package:tracket/features/matches/models/extras.dart';
import 'package:tracket/features/matches/models/fall_of_wickets.dart';
import 'package:tracket/features/matches/models/inning/inning.dart';
import 'package:tracket/features/matches/models/match.dart';
import 'package:tracket/features/matches/models/match_player_info.dart';
import 'package:tracket/features/matches/models/match_team_info.dart';
import 'package:tracket/features/matches/models/team_score.dart';
import 'package:tracket/features/matches/providers/extras_provider.dart';
import 'package:tracket/features/matches/utils/constants.dart';
import 'package:tracket/features/notifications/models/challenge_match.dart';
import 'package:tracket/features/notifications/models/notification.dart';
import 'package:tracket/features/notifications/services/notification_services.dart';
import 'package:tracket/features/players/models/bowling_figure.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:uuid/uuid.dart';

class MatchesServices {
  static final _firestore = FirebaseFirestore.instance;
  static const _uuid = Uuid();

  static Future<void> challengeForAMatch({
    required int matchFormatIndex,
    required MatchTeamInfo challengerTeam,
    required MatchTeamInfo challengedTeam,
    required DateTime matchDate,
    required TimeOfDay matchTime,
    required String matchVenue,
    required String challengerId,
    required String challengerName,
    required bool allowSpectators,
    required int noOfPlayers,
    required List<MatchPlayerInfo> challengerPlayers,
    required String matchType,
  }) async {
    final schedule = DateTime(
      matchDate.year,
      matchDate.month,
      matchDate.day,
      matchTime.hour,
      matchTime.minute,
    );

    final challengeMatch = ChallengeMatch(
      challengedTeam: challengedTeam,
      challengerId: challengerId,
      challengerName: challengerName,
      challengerTeam: challengerTeam,
      updatedAt: Timestamp.now(),
      allowSpectator: allowSpectators,
      challengedPlayers: [],
      challengerPlayers: challengerPlayers,
      noOfPlayers: noOfPlayers,
      schedule: schedule,
      venue: matchVenue,
      overs: MatchFormat.values[matchFormatIndex],
      matchType: Match.getMatchType(matchType),
    );

    try {
      final notification = NotificationModel.challenge(
        notificationId: _uuid.v4(),
        from: challengerTeam.teamId,
        to: challengedTeam.teamId,
        createdAt: Timestamp.now(),
        status: NotificationStatus.pending,
        read: false,
        challengeMatch: challengeMatch,
      );

      await _firestore
          .collection(FirestoreCollections.notification)
          .doc(notification.notificationId)
          .set(notification.toMap);

      final challengerPlayerCollectionRef = _firestore
          .collection(FirestoreCollections.notification)
          .doc(notification.notificationId)
          .collection(FirestoreCollections.challengerPlayers);

      for (final player in challengerPlayers) {
        await challengerPlayerCollectionRef
            .doc(player.playerId)
            .set(player.toMap);
      }

      await _firestore
          .collection(FirestoreCollections.teams)
          .doc(challengerTeam.teamId)
          .update({
        'challengedTeams': FieldValue.arrayUnion([notification.notificationId])
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<List<MatchPlayerInfo>> getChallengeMatchTeamPlayers({
    required String challengeId,
    required bool isChallenger,
  }) async {
    final List<MatchPlayerInfo> teamPlayers = [];

    try {
      final challengeDocRef = _firestore
          .collection(FirestoreCollections.notification)
          .doc(challengeId);
      if (isChallenger) {
        await challengeDocRef
            .collection(FirestoreCollections.challengerPlayers)
            .get()
            .then((value) {
          for (final player in value.docs) {
            teamPlayers.add(MatchPlayerInfo.fromMap(player.data()));
          }
        });
      } else {
        await challengeDocRef
            .collection(FirestoreCollections.challengedPlayers)
            .get()
            .then((value) {
          for (final player in value.docs) {
            teamPlayers.add(MatchPlayerInfo.fromMap(player.data()));
          }
        });
      }
    } catch (e) {
      print(e);
    }

    return teamPlayers;
  }

  static Future<void> acceptChallenge({
    required ChallengeMatch challenge,
    required String challengeId,
    required String acceptedBy,
    required BuildContext context,
  }) async {
    final match = Match(
      id: _uuid.v4(),
      challengerPlayerId: challenge.challengerId,
      challengeAcceptedBy: acceptedBy,
      participants: [
        challenge.challengerTeam.teamId,
        challenge.challengedTeam.teamId,
      ],
      team1: challenge.challengerTeam,
      team2: challenge.challengedTeam,
      team1Players: challenge.challengerPlayers,
      team2Players: challenge.challengedPlayers,
      noOfPlayer: challenge.noOfPlayers,
      isTeam1WonToss: null,
      tossDecision: null,
      createdAt: Timestamp.now(),
      matchFormat: challenge.overs,
      matchType: challenge.matchType,
      spectatorsAllowed: challenge.allowSpectator,
      updatedAt: Timestamp.now(),
      venue: challenge.venue,
      schedule: challenge.schedule,
    );

    try {
      final matchDocRef =
          _firestore.collection(FirestoreCollections.matches).doc(match.id);

      //* Storing match data
      await matchDocRef.set(match.toMap);

      if (!context.mounted) return;

      //* mark challenge as accepted
      await NotificationServices.markNotificationStatus(
        challengeId,
        NotificationStatus.accept,
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> setMatchStartBy({
    required String matchId,
    required String startBy,
  }) async {
    try {
      await _firestore
          .collection(FirestoreCollections.matches)
          .doc(matchId)
          .update({'startBy': startBy});
    } catch (e) {
      print(e);
    }
  }

  static Future<void> startMatch({
    required String matchId,
    required bool isTeam1WonToss,
    required TossDecision decision,
    required Inning inning1,
    required BattingScore striker,
    required BattingScore nonStriker,
    required BowlingScore bowler,
  }) async {
    try {
      final matchDocRef =
          _firestore.collection(FirestoreCollections.matches).doc(matchId);

      final inningDocRef = matchDocRef
          .collection(FirestoreCollections.innings)
          .doc(MatchConstant.inning1);

      //* set inning
      await inningDocRef.set(inning1.toMap());

      await inningDocRef
          .collection(FirestoreCollections.battingStats)
          .doc(striker.battingPosition.toString())
          .set(striker.toMap());

      await inningDocRef
          .collection(FirestoreCollections.battingStats)
          .doc(nonStriker.battingPosition.toString())
          .set(nonStriker.toMap());

      await inningDocRef
          .collection(FirestoreCollections.bowlingStats)
          .doc(bowler.uuid)
          .set(bowler.toMap());

      //* update match field
      final team1Score = TeamScore(runs: 0, balls: 0, wickets: 0);
      await matchDocRef.update({
        'isTeam1WonToss': isTeam1WonToss,
        'tossDecision': decision.name,
        'currentInningNumber': 1,
        'status': MatchStatus.live.name,
        'team1Score': team1Score.toMap(),
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<void> startSecondInning({
    required String matchId,
    required Inning inning2,
    required BattingScore striker,
    required BattingScore nonStriker,
    required BowlingScore bowler,
  }) async {
    try {
      final matchDocRef =
          _firestore.collection(FirestoreCollections.matches).doc(matchId);

      final inningDocRef = matchDocRef
          .collection(FirestoreCollections.innings)
          .doc(MatchConstant.inning2);

      //* set inning
      await inningDocRef.set(inning2.toMap());

      await inningDocRef
          .collection(FirestoreCollections.battingStats)
          .doc(striker.battingPosition.toString())
          .set(striker.toMap());

      await inningDocRef
          .collection(FirestoreCollections.battingStats)
          .doc(nonStriker.battingPosition.toString())
          .set(nonStriker.toMap());

      await inningDocRef
          .collection(FirestoreCollections.bowlingStats)
          .doc(bowler.uuid)
          .set(bowler.toMap());

      //* update match field
      final team2Score = TeamScore(runs: 0, balls: 0, wickets: 0);
      await matchDocRef.update({
        'currentInningNumber': 2,
        'team2Score': team2Score.toMap(),
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<List<Inning?>> getInningsFromMatchId(String matchId) async {
    // Create a list to store innings with their additional data
    final List<Inning?> innings = [];

    try {
      final matchDocRef =
          _firestore.collection(FirestoreCollections.matches).doc(matchId);

      // Fetch innings collection
      final inningSnap =
          await matchDocRef.collection(FirestoreCollections.innings).get();

      // Fetch data for each inning
      for (var inningDoc in inningSnap.docs) {
        // Convert inning document to Inning object
        final inningData = inningDoc.data();

        // Fetch batting scores for this inning
        final battingScoreSnap = await inningDoc.reference
            .collection(FirestoreCollections.battingStats)
            .get();

        // Fetch bowling scores for this inning
        final bowlingScoreSnap = await inningDoc.reference
            .collection(FirestoreCollections.bowlingStats)
            .get();

        final inning = Inning.fromMap(
          inningData,
          battingScore: battingScoreSnap.docs,
          bowlingScore: bowlingScoreSnap.docs,
        );

        innings.add(inning);
      }

      if (innings.length < 2) {
        innings.add(null);
      }
      if (innings.length < 1) {
        innings.add(null);
      }
    } catch (e) {
      print(e);
    }

    return innings;
  }

  static Future<void> updateMatchScore({
    required String matchId,
    required int currentInningNo,
    required int runs,
    required bool isFour,
    required bool isSix,
    required Extras teamExtras,
    required int strikerPosition,
    required int nonStrikerPosition,
    required String currentBowlerId,
    required ExtrasState extras,
    required TeamScore teamScore,
    required BallOutcome ballOutCome,
    required bool isOverCompleted,
    required bool isInningCompleted,
    required bool isMatchCompleted,
    FallOfWicket? fallOfWickets,
    bool isMaiden = false,
    bool isWicket = false,
    int? outBatsmanPosition,
    ReasonOfOut? reasonOfOut,
    String? dismissalInfo,
    String? winningTeamId,
    WinningMethod? winningMethod,
    int? winningMargin,
  }) async {
    final updatedExtra = teamExtras.addExtras(
      isWide: extras.isWide,
      isNoBall: extras.isNoBall,
      isBye: extras.isBye,
      isLegBye: extras.isLegBye,
      runs: runs,
    );

    final willBallAddedToTeamScore = !extras.isWide && !extras.isNoBall;
    int totalTeamRuns = 0;
    if (extras.isWide) {
      totalTeamRuns = 1 + runs;
    } else if (extras.isNoBall) {
      totalTeamRuns = 1 + runs;
    } else if (extras.isBye || extras.isLegBye) {
      totalTeamRuns = runs;
    } else {
      totalTeamRuns = runs;
    }

    try {
      await _updateCurrentBatsmenStats(
        matchId: matchId,
        currentInningNo: currentInningNo,
        strikerPosition: strikerPosition,
        nonStrikerPosition: nonStrikerPosition,
        runs: runs,
        isFour: isFour,
        isSix: isSix,
        extras: extras,
        isWicket: isWicket,
        outBatsmanPosition: outBatsmanPosition,
        reasonOfOut: reasonOfOut,
        dismissalInfo: dismissalInfo,
      );

      await _updateCurrentBowlerStats(
        matchId: matchId,
        currentInningNo: currentInningNo,
        currentBowlerId: currentBowlerId,
        extras: extras,
        runs: runs,
        isWicket: reasonOfOut == ReasonOfOut.runOut ? false : isWicket,
        isOverCompleted: isOverCompleted,
        isMaidenOver: isMaiden,
      );
    } catch (e) {
      print(e);
    }

    int newStrikerPosition = strikerPosition;
    int newNonStrikerPosition = nonStrikerPosition;

    if ((runs.isOdd && !isOverCompleted) || (isOverCompleted && runs.isEven)) {
      newStrikerPosition = nonStrikerPosition;
      newNonStrikerPosition = strikerPosition;
    }

    try {
      final matchDocRef =
          _firestore.collection(FirestoreCollections.matches).doc(matchId);

      await matchDocRef.update({
        'team${currentInningNo}Score': teamScore.toMap(),
        if (isMatchCompleted) ...{
          'status': MatchStatus.completed.name,
          'winningTeamId': winningTeamId,
          'winningMethod': winningMethod!.name,
          'winningMargin': winningMargin,
        }
      });

      await matchDocRef
          .collection(FirestoreCollections.innings)
          .doc('inning$currentInningNo')
          .update(
        {
          if (willBallAddedToTeamScore) 'balls': FieldValue.increment(1),
          'extras': updatedExtra.toMap(),
          if (isFour) 'fours': FieldValue.increment(1),
          'runs': FieldValue.increment(totalTeamRuns),
          if (isSix) 'sixes': FieldValue.increment(1),
          if (isWicket) 'wickets': FieldValue.increment(1),
          if (nonStrikerPosition != newNonStrikerPosition)
            'nonStrikerPosition': newNonStrikerPosition,
          if (strikerPosition != newStrikerPosition)
            'strikerPosition': newStrikerPosition,
          if (fallOfWickets != null)
            'fallOfWickets': FieldValue.arrayUnion([fallOfWickets.toMap()]),
          if (isInningCompleted) 'status': InningsStatus.completed.name,
        },
      );

      await matchDocRef
          .collection(FirestoreCollections.balls)
          .doc(ballOutCome.ballId)
          .set(ballOutCome.toMap());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> _updateCurrentBatsmenStats({
    required String matchId,
    required int currentInningNo,
    required int strikerPosition,
    required int nonStrikerPosition,
    required int runs,
    required bool isFour,
    required bool isSix,
    required ExtrasState extras,
    bool isWicket = false,
    ReasonOfOut? reasonOfOut,
    int? outBatsmanPosition,
    String? dismissalInfo,
  }) async {
    final battingStatCollectionRef = _firestore
        .collection(FirestoreCollections.matches)
        .doc(matchId)
        .collection(FirestoreCollections.innings)
        .doc('inning$currentInningNo')
        .collection(FirestoreCollections.battingStats);

    int strikerRuns = 0;
    int strikerBalls = 0;
    bool isStrikerOut = false;

    bool isNonStrikerOut = false;

    //* Wicket handling:
    if (isWicket) {
      //* If the striker is out (or for run-outs affecting the non-striker)
      if (outBatsmanPosition == null || outBatsmanPosition == strikerPosition) {
        strikerRuns = runs;
        strikerBalls = extras.isWide ? 0 : 1;
        isStrikerOut = true;
      } else {
        //* Non-striker gets dismissed (commonly in a run-out).
        isNonStrikerOut = true;
      }
    } else {
      //* Add runs only if the delivery is not “extra” (i.e. wide, bye, leg bye,
      //* or a no-ball that resulted in bye/leg bye).
      if (extras.shouldAddRunsToBowler) {
        strikerBalls = 1;
        strikerRuns = runs;
      }
    }

    try {
      await battingStatCollectionRef.doc(strikerPosition.toString()).update({
        'ballsFaced': FieldValue.increment(strikerBalls),
        if (isFour) 'fours': FieldValue.increment(1),
        if (isSix) 'sixes': FieldValue.increment(1),
        if (isStrikerOut) 'isOut': true,
        if (isStrikerOut && reasonOfOut != null)
          'reasonOfOut': reasonOfOut.name,
        if (dismissalInfo != null) 'dismissalInfo': dismissalInfo,
        'runs': FieldValue.increment(strikerRuns),
      });

      await battingStatCollectionRef.doc(nonStrikerPosition.toString()).update({
        'isOut': isNonStrikerOut,
        if (isNonStrikerOut && reasonOfOut != null)
          'reasonOfOut': reasonOfOut.name,
        if (dismissalInfo != null) 'dismissalInfo': dismissalInfo,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> _updateCurrentBowlerStats({
    required String matchId,
    required int currentInningNo,
    required String currentBowlerId,
    required ExtrasState extras,
    required int runs,
    bool isOverCompleted = false,
    bool isMaidenOver = false,
    bool isWicket = false,
  }) async {
    final bowlerStatDocRef = _firestore
        .collection(FirestoreCollections.matches)
        .doc(matchId)
        .collection(FirestoreCollections.innings)
        .doc('inning$currentInningNo')
        .collection(FirestoreCollections.bowlingStats)
        .doc(currentBowlerId);

    bool isBallAdd = !extras.isWide && !extras.isNoBall;
    bool isDot = runs == 0 && !extras.isWide && !extras.isNoBall;
    int runsForBowler = 0;

    if (extras.isWide) {
      runsForBowler = 1 + runs;
    } else if (extras.isNoBall) {
      if (extras.isBye || extras.isLegBye) {
        runsForBowler = 1;
      } else {
        runsForBowler = 1 + runs;
      }
    } else if (extras.isBye || extras.isLegBye) {
      runsForBowler = 0;
    } else {
      runsForBowler = runs;
    }

    try {
      await bowlerStatDocRef.update({
        if (isBallAdd) 'balls': FieldValue.increment(1),
        if (isDot) 'dots': FieldValue.increment(1),
        if (extras.isNoBall) 'noBalls': FieldValue.increment(1),
        'runsGiven': FieldValue.increment(runsForBowler),
        if (isWicket) 'wickets': FieldValue.increment(1),
        if (extras.isWide) 'wides': FieldValue.increment(1),
        if (isMaidenOver && isOverCompleted)
          'maidenOvers': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> deleteBallsCollection(String matchId) async {
    final collectionRef = _firestore
        .collection(FirestoreCollections.matches)
        .doc(matchId)
        .collection(FirestoreCollections.balls);

    const batchSize = 50;
    Query query = collectionRef.limit(batchSize);

    while (true) {
      final querySnapshot = await query.get();
      if (querySnapshot.docs.isEmpty) break;

      // Delete documents in the current batch
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Paginate to the next batch
      final lastDoc = querySnapshot.docs.last;
      query = collectionRef.startAfterDocument(lastDoc).limit(batchSize);
    }
  }

  static Future<List<BallOutcome>> getCurrentOverRuns(String matchId) async {
    final currentOversSnap = await _firestore
        .collection(FirestoreCollections.matches)
        .doc(matchId)
        .collection(FirestoreCollections.balls)
        .orderBy('timestamp')
        .get();

    final docs = currentOversSnap.docs;

    return BallOutcome.fromQuerySnapshot(docs);
  }

  static Future<void> setNewBatsmanOnWicket({
    required String matchId,
    required int currentInningNo,
    required BattingScore newBatsmanStat,
    required int strikerPosition,
    required int nonStrikerPosition,
  }) async {
    final inningDocRef = _firestore
        .collection(FirestoreCollections.matches)
        .doc(matchId)
        .collection(FirestoreCollections.innings)
        .doc('inning$currentInningNo');

    try {
      await inningDocRef.update({
        'strikerPosition': strikerPosition,
        'nonStrikerPosition': nonStrikerPosition,
      });

      await inningDocRef
          .collection(FirestoreCollections.battingStats)
          .doc(newBatsmanStat.battingPosition.toString())
          .set(newBatsmanStat.toMap());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> setNewBowlerOnOverCompleted({
    required String matchId,
    required int currentInningNo,
    required BowlingScore? newBowlerStat,
    required String currentBowlerId,
  }) async {
    final inningDocRef = _firestore
        .collection(FirestoreCollections.matches)
        .doc(matchId)
        .collection(FirestoreCollections.innings)
        .doc('inning$currentInningNo');

    try {
      await inningDocRef.update({
        'currentBowlerId': currentBowlerId,
      });

      if (newBowlerStat != null)
        await inningDocRef
            .collection(FirestoreCollections.bowlingStats)
            .doc(newBowlerStat.uuid)
            .set(newBowlerStat.toMap());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Updates player statistics after match completion
  static Future<void> addMatchStatsToCorrespondingPlayers({
    required MatchFormat matchFormat,
    required List<MatchPlayerInfo> team1Players,
    required List<MatchPlayerInfo> team2Players,
    required List<BattingScore> inning1BattingStats,
    required List<BowlingScore> inning1BowlingStats,
    required List<BattingScore> inning2BattingStats,
    required List<BowlingScore> inning2BowlingStats,
  }) async {
    try {
      final allPlayersId = [
        ...team1Players.map((player) => player.playerId),
        ...team2Players.map((player) => player.playerId),
      ];

      final uniquePlayerIds = allPlayersId.toSet().toList();

      // Exit early if there are no players to update
      if (uniquePlayerIds.isEmpty) return;

      final allBattingStats = [...inning1BattingStats, ...inning2BattingStats];
      final allBowlingStats = [...inning1BowlingStats, ...inning2BowlingStats];

      // Create a batch for all updates
      final batch = _firestore.batch();

      // Firestore whereIn has value count limits; chunk requests for reliability.
      const whereInChunkSize = 10;
      final Map<String, DocumentReference<Map<String, dynamic>>>
          playerDocRefMap = {};

      for (int start = 0;
          start < uniquePlayerIds.length;
          start += whereInChunkSize) {
        final end = (start + whereInChunkSize > uniquePlayerIds.length)
            ? uniquePlayerIds.length
            : start + whereInChunkSize;
        final chunk = uniquePlayerIds.sublist(start, end);

        final querySnapshot = await _firestore
            .collection(FirestoreCollections.players)
            .where('playerId', whereIn: chunk)
            .get();

        for (final doc in querySnapshot.docs) {
          final data = doc.data();
          final playerId = (data['playerId'] as String?) ?? doc.id;
          playerDocRefMap[playerId] = doc.reference;
        }
      }

      // Get all player stats docs in parallel.
      final Map<String, DocumentSnapshot<Map<String, dynamic>>> playerStatsMap =
          {};
      final Map<String, DocumentReference<Map<String, dynamic>>>
          playerStatsRefMap = {};
      final List<Future<void>> statsFutures = [];

      for (final playerId in uniquePlayerIds) {
        final playerDocRef = playerDocRefMap[playerId];
        if (playerDocRef == null) continue;

        final statsDocRef = playerDocRef
            .collection(FirestoreCollections.stats)
            .doc(matchFormat.name);
        playerStatsRefMap[playerId] = statsDocRef;

        statsFutures.add(statsDocRef.get().then((snapshot) {
          playerStatsMap[playerId] = snapshot;
        }));
      }

      // Wait for all stats queries to complete
      await Future.wait(statsFutures);

      // Process batting stats
      _processBattingStats(
          batch: batch,
          allBattingStats: allBattingStats,
          playerStatsMap: playerStatsMap,
          playerStatsRefMap: playerStatsRefMap,
          matchFormat: matchFormat);

      // Process bowling stats
      _processBowlingStats(
          batch: batch,
          allBowlingStats: allBowlingStats,
          playerStatsMap: playerStatsMap,
          playerStatsRefMap: playerStatsRefMap,
          matchFormat: matchFormat);

      // Update match count for all players
      for (final playerId in uniquePlayerIds) {
        final statsDocRef = playerStatsRefMap[playerId];
        if (statsDocRef == null) continue;

        batch.set(
          statsDocRef,
          {'matches': FieldValue.increment(1)},
          SetOptions(merge: true),
        );
      }

      // Commit all updates in one batch
      await batch.commit();
    } catch (e) {
      debugPrint('Error updating player stats: ${e.toString()}');
      // Consider implementing proper error handling/retry mechanism here
    }
  }

  /// Process and update batting statistics for all players
  static void _processBattingStats({
    required WriteBatch batch,
    required List<BattingScore> allBattingStats,
    required Map<String, DocumentSnapshot<Map<String, dynamic>>> playerStatsMap,
    required Map<String, DocumentReference<Map<String, dynamic>>>
        playerStatsRefMap,
    required MatchFormat matchFormat,
  }) {
    for (final battingStat in allBattingStats) {
      final playerId = battingStat.uuid;
      final playerStats = playerStatsMap[playerId];
      final playerStatsRef = playerStatsRefMap[playerId];

      if (playerStatsRef == null) continue;

      final data = playerStats?.data();
      final highestScore =
          (data?['battingStats']?['highestScore'] as num?)?.toInt() ?? 0;
      final needToUpdateHighScore = battingStat.runs > highestScore;

      final Map<String, dynamic> updates = {
        'battingStats.ballsFaced': FieldValue.increment(battingStat.ballsFaced),
        'battingStats.four': FieldValue.increment(battingStat.fours),
        'battingStats.six': FieldValue.increment(battingStat.sixes),
        'battingStats.innings': FieldValue.increment(1),
        'battingStats.totalRuns': FieldValue.increment(battingStat.runs),
      };

      if (battingStat.isOut) {
        updates['battingStats.outCount'] = FieldValue.increment(1);
      }

      if (needToUpdateHighScore) {
        updates['battingStats.highestScore'] = battingStat.runs;
      }

      if (battingStat.runs >= 50 && battingStat.runs < 100) {
        updates['battingStats.fifties'] = FieldValue.increment(1);
      } else if (battingStat.runs >= 100 && battingStat.runs < 200) {
        updates['battingStats.hundreds'] = FieldValue.increment(1);
      }

      batch.set(
        playerStatsRef,
        updates,
        SetOptions(merge: true),
      );
    }
  }

  /// Process and update bowling statistics for all players
  static void _processBowlingStats({
    required WriteBatch batch,
    required List<BowlingScore> allBowlingStats,
    required Map<String, DocumentSnapshot<Map<String, dynamic>>> playerStatsMap,
    required Map<String, DocumentReference<Map<String, dynamic>>>
        playerStatsRefMap,
    required MatchFormat matchFormat,
  }) {
    for (final bowlingStat in allBowlingStats) {
      final playerId = bowlingStat.uuid;
      final playerStats = playerStatsMap[playerId];
      final playerStatsRef = playerStatsRefMap[playerId];

      if (playerStatsRef == null) continue;

      final data = playerStats?.data();
      final Map<String, dynamic> bestBowlingFigure = (data?['bowlingStats']
              ?['bestBallingFigure'] as Map<String, dynamic>?) ??
          {'wicket': 0, 'runGiven': 0, 'ballDelivered': 0};

      bool needToUpdateBestBowling = _shouldUpdateBestBowling(
        currentWickets: bowlingStat.wickets,
        currentRuns: bowlingStat.runsGiven,
        currentBalls: bowlingStat.balls,
        bestFigure: bestBowlingFigure,
      );

      final Map<String, dynamic> updates = {
        'bowlingStats.ballDelivered': FieldValue.increment(bowlingStat.balls),
        'bowlingStats.maiden': FieldValue.increment(bowlingStat.maidenOvers),
        'bowlingStats.runGiven': FieldValue.increment(bowlingStat.runsGiven),
        'bowlingStats.wicket': FieldValue.increment(bowlingStat.wickets),
      };

      if (needToUpdateBestBowling) {
        updates['bowlingStats.bestBallingFigure'] = BowlingFigure(
          runGiven: bowlingStat.runsGiven,
          ballDelivered: bowlingStat.balls,
          wicket: bowlingStat.wickets,
        ).toJson;
      }

      batch.set(
        playerStatsRef,
        updates,
        SetOptions(merge: true),
      );
    }
  }

  /// Determines if current bowling figure is better than previous best
  static bool _shouldUpdateBestBowling({
    required int currentWickets,
    required int currentRuns,
    required int currentBalls,
    required Map<String, dynamic> bestFigure,
  }) {
    final bestWickets = bestFigure['wicket'] ?? 0;
    final bestRuns = bestFigure['runGiven'] ?? 0;
    final bestBalls = bestFigure['ballDelivered'] ?? 0;

    // More wickets is always better
    if (currentWickets > bestWickets) return true;

    // Same wickets, but fewer runs or fewer balls is better
    if (currentWickets == bestWickets) {
      if (currentRuns < bestRuns) return true;
      if (currentRuns == bestRuns && currentBalls < bestBalls) return true;
    }

    return false;
  }

  /// Updates team statistics after match completion
  static Future<void> updateTeamStatsAfterMatchCompletion({
    required String team1Id,
    required String team2Id,
    required MatchFormat matchFormat,
    required bool isTeam1Won,
  }) async {
    try {
      final batch = _firestore.batch();

      // Get both team stats documents in parallel
      final teamStatsRefs = await Future.wait([
        _firestore
            .collection(FirestoreCollections.teams)
            .doc(team1Id)
            .collection(FirestoreCollections.stats)
            .doc(matchFormat.name)
            .get(),
        _firestore
            .collection(FirestoreCollections.teams)
            .doc(team2Id)
            .collection(FirestoreCollections.stats)
            .doc(matchFormat.name)
            .get(),
      ]);

      // Team 1 updates
      if (teamStatsRefs[0].exists) {
        batch.update(
          teamStatsRefs[0].reference,
          {
            'matches': FieldValue.increment(1),
            'wins':
                isTeam1Won ? FieldValue.increment(1) : FieldValue.increment(0),
            'losses':
                !isTeam1Won ? FieldValue.increment(1) : FieldValue.increment(0),
          },
        );
      } else {
        batch.set(
          teamStatsRefs[0].reference,
          {
            'matches': 1,
            'wins': isTeam1Won ? 1 : 0,
            'losses': !isTeam1Won ? 1 : 0,
          },
        );
      }

      // Team 2 updates
      if (teamStatsRefs[1].exists) {
        batch.update(
          teamStatsRefs[1].reference,
          {
            'matches': FieldValue.increment(1),
            'wins':
                !isTeam1Won ? FieldValue.increment(1) : FieldValue.increment(0),
            'losses':
                isTeam1Won ? FieldValue.increment(1) : FieldValue.increment(0),
          },
        );
      } else {
        batch.set(
          teamStatsRefs[1].reference,
          {
            'matches': 1,
            'wins': !isTeam1Won ? 1 : 0,
            'losses': isTeam1Won ? 1 : 0,
          },
        );
      }

      await batch.commit();
    } catch (e) {
      debugPrint('Error updating team stats: ${e.toString()}');
      // Consider implementing proper error handling/retry mechanism here
    }
  }
}
