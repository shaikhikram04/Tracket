import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/notifications/models/challenge_match.dart';
import 'package:tracket/notifications/models/notification.dart' as model;
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
      noOfPlayers: noOfPlayers,
      schedule: schedule,
      venue: matchVenue,
      overs: MatchFormat.values[matchFormatIndex],
      matchType: Match.getMatchType(matchType),
    );

    final notification = model.Notification.challenge(
      notificationId: _uuid.v4(),
      from: challengerTeam.teamId,
      to: challengedTeam.teamId,
      type: model.NotificationType.matchChallenge,
      createdAt: Timestamp.now(),
      status: model.NotificationStatus.pending,
      read: false,
      title: '',
      body: '',
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

    for (final player in challengerTeam.teamPlayers) {
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

  // static createMatch(ChallengeMatch challegeMatch) {
  //   final match = Match(
  //     team1: challegeMatch.challengerTeam,
  //     team2: challegeMatch.challengedTeam,
  //     noOfPlayer: challegeMatch.noOfPlayers,
  //     isTeam1WonToss: null,
  //     tossDecision: null,
  //     createdAt: Timestamp.now(),
  //     matchFormat: challegeMatch.overs,
  //     matchType: challegeMatch.matchType,
  //     spectatorsAllowed: challegeMatch.allowSpectator,
  //     updatedAt: Timestamp.now(),
  //     venue: challegeMatch.venue,
  //     schedule: challegeMatch.schedule,
  //   );

  //   _firestore
  //       .collection(FirestoreCollections.matches)
  //       .doc(match.id)
  //       .set(match.toMap);
  // }

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
    required BuildContext context,
  }) async {
    final match = Match(
      team1: challenge.challengerTeam,
      team2: challenge.challengedTeam,
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

    //* Storing match data
    await _firestore
        .collection(FirestoreCollections.matches)
        .doc(match.id)
        .set(match.toMap);

    if (!context.mounted) return;

    // //* deleting challenge notification
    // await NotificationServices.deleteNotification(
    //     notificationId: challengeId,
    //     type: model.NotificationType.matchChallenge,
    //     context: context);
  }
}
