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
    required this.allowSpectator,
    required this.challengedPlayers,
    required this.challengerPlayers,
    required this.noOfPlayers,
    required this.overs,
    required this.venue,
    required this.schedule,
    required this.matchType,
  });

  final TeamDetails challengerTeam;
  final TeamDetails challengedTeam;
  final String challengerId;
  final String challengerName;
  final MatchFormat overs;
  final String venue;
  final DateTime schedule;
  final bool allowSpectator;
  final Timestamp updatedAt;
  final int noOfPlayers;
  final MatchType matchType;
  final List<PlayerDetails> challengerPlayers;
  final List<PlayerDetails> challengedPlayers;

  Map<String, dynamic> get toMap => {
        'challengerTeam': challengerTeam.toMap,
        'challengedTeam': challengedTeam.toMap,
        'challengerId': challengerId,
        'challengerName': challengerName,
        'schedule': Timestamp.fromDate(schedule),
        'venue': venue,
        'overs': overs.name,
        'allowSpectator': allowSpectator,
        'updatedAt': updatedAt,
        'noOfPlayers': noOfPlayers,
        'matchType': matchType.name
      };

  static ChallengeMatch formMap(
          Map<String, dynamic> snap,
          List<QueryDocumentSnapshot> challengerPlayer,
          List<QueryDocumentSnapshot> challengedPlayer) =>
      ChallengeMatch(
        challengedTeam: TeamDetails.formMap(snap['challengedTeam']),
        challengerId: snap['challengerId'],
        challengerName: snap['challengerName'],
        challengerTeam: TeamDetails.formMap(snap['challengerTeam']),
        updatedAt: snap['updatedAt'],
        allowSpectator: snap['allowSpectator'],
        challengedPlayers: [], // TODO : wrote function for fetch store players
        challengerPlayers: [], // TODO : wrote function for fetch store players
        noOfPlayers: snap['noOfPlayers'],
        overs: Match.getMatchFormat(snap['overs']),
        venue: snap['venue'],
        schedule: snap['schedule'].toDate(),
        matchType: Match.getMatchType(snap['matchType']),
      );
}
