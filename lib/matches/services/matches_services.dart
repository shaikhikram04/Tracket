import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/matches/models/inning.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/models/team_score.dart';
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
  }) async {
    final docRef =
        _firestore.collection(FirestoreCollections.matches).doc(matchId);

    await docRef
        .collection(FirestoreCollections.innings)
        .doc(MatchConstant.inning1)
        .set(inning1.toMap());

    final team1Score = TeamScore(runs: 0, balls: 0, wickets: 0);

    await docRef.update({
      'isTeam1WonToss': isTeam1WonToss,
      'tossDecision': decision.name,
      'currentInningNumber': 1,
      'status': MatchStatus.live.name,
      'team1Score': team1Score.toMap(),
    });
  }

  static Future<List<Inning?>> getInningsFromMatchId(String matchId) async {
    final inningSnap = await _firestore
        .collection(FirestoreCollections.matches)
        .doc(matchId)
        .collection(FirestoreCollections.innings)
        .get();

    final innings = inningSnap.docs;

    Inning? inning1, inning2;

    if (innings.length >= 1) {
      final inning1Data = innings[0].data();
      inning1 = Inning.fromMap(inning1Data);
    }

    if (innings.length == 2) {
      final inning2Data = innings[1].data();
      inning2 = Inning.fromMap(inning2Data);
    }

    return [inning1, inning2];
  }
}
