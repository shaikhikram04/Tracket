import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';

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

  final MatchTeamInfo challengerTeam;
  final MatchTeamInfo challengedTeam;
  final String challengerId;
  final String challengerName;
  final MatchFormat overs;
  final String venue;
  final DateTime schedule;
  final bool allowSpectator;
  final Timestamp updatedAt;
  final int noOfPlayers;
  final MatchType matchType;
  List<MatchPlayerInfo> challengerPlayers;
  List<MatchPlayerInfo> challengedPlayers;

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
    List<QueryDocumentSnapshot>? challengerPlayer,
    List<QueryDocumentSnapshot>? challengedPlayer,
  ) =>
      ChallengeMatch(
        challengedTeam: MatchTeamInfo.fromMap(snap['challengedTeam']),
        challengerId: snap['challengerId'],
        challengerName: snap['challengerName'],
        challengerTeam: MatchTeamInfo.fromMap(snap['challengerTeam']),
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

  void setChallengerPlayers(List<MatchPlayerInfo> players) {
    challengerPlayers = players;
  }

  void setChallengedPlayers(List<MatchPlayerInfo> players) {
    challengedPlayers = players;
  }
}
