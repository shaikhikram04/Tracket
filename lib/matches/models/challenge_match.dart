import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracket/teams/models/team_details.dart';

enum ChallengeStatus {
  pending,
  accept,
  decline,
}

class MatchDetail {
  const MatchDetail({
    required this.date,
    required this.venue,
    required this.time,
    required this.overs,
  });
  final int overs;
  final String venue;
  final DateTime date;
  final TimeOfDay time;
}

class ChallengeMatch {
  ChallengeMatch({
    required this.challengeStatus,
    required this.challengedTeam,
    required this.challengerId,
    required this.challengerName,
    required this.challengerTeam,
    required this.createdAt,
    required this.matchDetails,
    required this.matchId,
    required this.updatedAt,
    required this.willLive,
  });

  final String matchId;
  final ChallengeStatus challengeStatus;
  final TeamDetails challengerTeam;
  final TeamDetails challengedTeam;
  final String challengerId;
  final String challengerName;
  final MatchDetail matchDetails;
  final bool willLive;
  final Timestamp createdAt;
  final Timestamp updatedAt;
}
