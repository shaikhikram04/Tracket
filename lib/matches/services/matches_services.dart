import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/matches/models/challenge_match.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_detail.dart';
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
  }) async {
    final schedule = DateTime(
      matchDate.year,
      matchDate.month,
      matchDate.day,
      matchTime.hour,
      matchTime.minute,
    );
    final matchDetail = MatchDetail(
      schedule: schedule,
      venue: matchVenue,
      overs: MatchFormat.values[matchFormatIndex],
    );

    final challengeMatch = ChallengeMatch(
      challengeStatus: ChallengeStatus.pending,
      challengedTeam: challengedTeam,
      challengerId: challengerId,
      challengerName: challengerName,
      challengerTeam: challengerTeam,
      createdAt: Timestamp.now(),
      matchDetails: matchDetail,
      matchId: _uuid.v4(),
      updatedAt: Timestamp.now(),
      willLive: allowSpectators,
      challengedPlayers: [],
      challengerPlayers: challengerPlayers,
      noOfPlayers: noOfPlayers,
    );

    await _firestore
        .collection(FirestoreCollections.challengeMatch)
        .doc(challengeMatch.matchId)
        .set(challengeMatch.toMap);

    for (final player in challengerPlayers) {
      await _firestore
          .collection(FirestoreCollections.challengeMatch)
          .doc(challengeMatch.matchId)
          .collection(FirestoreCollections.challengerPlayers)
          .doc(player.id)
          .set(player.toMap);
    }
  }
}
