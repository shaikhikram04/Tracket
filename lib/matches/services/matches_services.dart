import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/notifications/models/challenge_match.dart';
import 'package:tracket/notifications/models/notification.dart' as model;
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';
import 'package:uuid/uuid.dart';

class MatchesServices {
  static final _firestore = FirebaseFirestore.instance;
  static const _uuid = Uuid();

  static Future<void> challegeForAMatch({
    required int matchFormatIndex,
    required TeamDetails challengerTeam,
    required TeamDetails challengedTeam,
    required DateTime matchDate,
    required TimeOfDay matchTime,
    required String matchVenue,
    required String challengerId,
    required String challengerName,
    required bool allowSpectators,
    required int noOfPlayers,
    required List<PlayerDetails> challengerPlayers,
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
      willLive: allowSpectators,
      challengedPlayers: [],
      challengerPlayers: challengerPlayers,
      noOfPlayers: noOfPlayers,
      schedule: schedule,
      venue: matchVenue,
      overs: MatchFormat.values[matchFormatIndex],
      matchType: Match.getMatchType(matchType),
    );

    final notification = model.Notification.challenge(
      notificationId: _uuid.v4(),
      from: challengerTeam.id,
      to: challengedTeam.id,
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

    for (final player in challengerPlayers) {
      await challengerPlayerCollectionRef.doc(player.id).set(player.toMap);
    }
  }

  static createMatch(ChallengeMatch challegeMatch) {
    final match = Match(
      team1: challegeMatch.challengerTeam,
      team2: challegeMatch.challengedTeam,
      noOfPlayer: challegeMatch.noOfPlayers,
      isTeam1WonToss: null,
      tossDecision: null,
      createdAt: Timestamp.now(),
      matchFormat: challegeMatch.overs,
      matchType: challegeMatch.matchType,
      spectatorsAllowed: challegeMatch.willLive,
      updatedAt: Timestamp.now(),
      venue: challegeMatch.venue,
      team1Players: [],
      team2Players: [],
      schedule: challegeMatch.schedule,
    );
  }
}
