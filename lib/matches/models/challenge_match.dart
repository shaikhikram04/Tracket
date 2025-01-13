import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team_details.dart';

enum ChallengeStatus {
  pending,
  accept,
  decline,
}

class ChallengeMatch {
  ChallengeMatch({
    required this.challengedTeam,
    required this.challengerId,
    required this.challengerName,
    required this.challengerTeam,
    required this.updatedAt,
    required this.willLive,
    required this.challengedPlayers,
    required this.challengerPlayers,
    required this.noOfPlayers,
    required this.overs,
    required this.venue,
    required this.schedule,
  });

  final TeamDetails challengerTeam;
  final TeamDetails challengedTeam;
  final String challengerId;
  final String challengerName;
  final MatchFormat overs;
  final String venue;
  final DateTime schedule;
  final bool willLive;
  final Timestamp updatedAt;
  final int noOfPlayers;
  final List<PlayerDetails> challengerPlayers;
  final List<PlayerDetails> challengedPlayers;

  Map<String, dynamic> get toMap => {
        'challengerTeam': challengedTeam.toMap,
        'challengedTeam': challengedTeam.toMap,
        'challengerId': challengerId,
        'challengerName': challengerName,
        'schedule': Timestamp.fromDate(schedule),
        'venue': venue,
        'overs': overs.name,
        'willLive': willLive,
        'updatedAt': updatedAt,
        'noOfPlayers': noOfPlayers,
      };
}
