import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/matches/models/ball_outcome.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/matches/models/extras.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/models/team_score.dart';
import 'package:tracket/matches/providers/extras_provider.dart';
import 'package:tracket/matches/utils/constants.dart';
import 'package:tracket/notifications/models/challenge_match.dart';
import 'package:tracket/notifications/models/notification.dart';
import 'package:tracket/notifications/services/notification_services.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:uuid/uuid.dart';

class MatchesServices {
  static final _firestore = FirebaseFirestore.instance;
  static const _uuid = Uuid();

  static Future<void> challegeForAMatch({
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

    _firestore
        .collection(FirestoreCollections.teams)
        .doc(challengerTeam.teamId)
        .update({
      'challengedTeams': FieldValue.arrayUnion([notification.notificationId])
    });
  }

  static createMatch(
    ChallengeMatch challegeMatch,
    String acceptedBy,
  ) {
    final match = Match(
      challengerPlayerId: challegeMatch.challengerId,
      challengeAcceptedBy: acceptedBy,
      participants: [
        challegeMatch.challengerTeam.teamId,
        challegeMatch.challengedTeam.teamId,
      ],
      team1: challegeMatch.challengerTeam,
      team2: challegeMatch.challengedTeam,
      noOfPlayer: challegeMatch.noOfPlayers,
      isTeam1WonToss: null,
      tossDecision: null,
      createdAt: Timestamp.now(),
      matchFormat: challegeMatch.overs,
      matchType: challegeMatch.matchType,
      spectatorsAllowed: challegeMatch.allowSpectator,
      updatedAt: Timestamp.now(),
      venue: challegeMatch.venue,
      team1Players: [],
      team2Players: [],
      schedule: challegeMatch.schedule,
    );

    _firestore
        .collection(FirestoreCollections.matches)
        .doc(match.id)
        .set(match.toMap);
  }

  static Future<List<MatchPlayerInfo>> getChallengeMatchTeamPlayers({
    required String challengeId,
    required bool isChallenger,
  }) async {
    final List<MatchPlayerInfo> teamPlayers = [];

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
      challengeDocRef
          .collection(FirestoreCollections.challengedPlayers)
          .get()
          .then((value) {
        for (final player in value.docs) {
          teamPlayers.add(MatchPlayerInfo.fromMap(player.data()));
        }
      });
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
  }

  static Future<void> setMatchStartBy({
    required String matchId,
    required String startBy,
  }) async {
    await _firestore
        .collection(FirestoreCollections.matches)
        .doc(matchId)
        .update({'startBy': startBy});
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
        .doc(nonStriker.uuid.toString())
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
  }

  static Future<List<Inning?>> getInningsFromMatchId(String matchId) async {
    final matchDocRef =
        _firestore.collection(FirestoreCollections.matches).doc(matchId);

    // Fetch innings collection
    final inningSnap =
        await matchDocRef.collection(FirestoreCollections.innings).get();

    // Create a list to store innings with their additional data
    final List<Inning?> innings = [];

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
    bool isMaiden = false,
    bool isWicket = false,
    int? outBatsmanPosition,
    ReasonOfOut? reasonOfOut,
  }) async {
    final updatedExtra = teamExtras.addExtras(
      isWide: extras.isWide,
      isNoBall: extras.isNoBall,
      isBye: extras.isBye,
      isLegBye: extras.isLegBye,
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
    );

    await _updateCurrentBowlerStats(
      matchId: matchId,
      currentInningNo: currentInningNo,
      currentBowlerId: currentBowlerId,
      extras: extras,
      runs: runs,
      isWicket: isWicket,
      isOverCompleted: isOverCompleted,
      isMaidenOver: isMaiden,
    );

    int newStrikerPosition = strikerPosition;
    int newNonStrikerPosition = nonStrikerPosition;

    if ((runs.isOdd && !isOverCompleted) || (isOverCompleted && runs.isEven)) {
      newStrikerPosition = nonStrikerPosition;
      newNonStrikerPosition = strikerPosition;
    }

    try {
      final matchDocRef =
          _firestore.collection(FirestoreCollections.matches).doc(matchId);

      final updatedTeamScore = teamScore.addDelevery(
          runs: runs, isAddBall: willBallAddedToTeamScore, isWicket: isWicket);

      matchDocRef.update({
        'team${currentInningNo}Score': updatedTeamScore.toMap(),
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
          if (isWicket) 'wicket': FieldValue.increment(1),
          if (nonStrikerPosition != newNonStrikerPosition)
            'nonStrikerPosition': newNonStrikerPosition,
          if (strikerPosition != newStrikerPosition)
            'strikerPosition': newStrikerPosition,
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
        'runs': FieldValue.increment(strikerRuns),
      });

      await battingStatCollectionRef.doc(nonStrikerPosition.toString()).update({
        'isOut': isNonStrikerOut,
        if (isNonStrikerOut && reasonOfOut != null)
          'reasonOfOut': reasonOfOut.name,
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

    bool isballAdd = !extras.isWide && !extras.isNoBall;
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
        if (isballAdd) 'balls': FieldValue.increment(1),
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
}
