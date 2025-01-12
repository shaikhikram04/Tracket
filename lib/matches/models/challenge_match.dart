import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/matches/models/match_detail.dart';
import 'package:tracket/teams/models/team_details.dart';

enum ChallengeStatus {
  pending,
  accept,
  decline,
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

  Map<String, dynamic> get toMap => {
        'matchId': matchId,
        'challengeStatus': challengeStatus.name,
        'challengerTeam': challengedTeam.toMap,
        'challengedTeam': challengedTeam.toMap,
        'challengerId': challengerId,
        'challengerName': challengerName,
        'matchDetails': matchDetails.toMap,
        'willLive': willLive,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
