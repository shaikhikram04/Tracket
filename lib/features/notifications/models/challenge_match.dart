import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/features/matches/models/match.dart';
import 'package:tracket/features/matches/models/match_player_info.dart';
import 'package:tracket/features/matches/models/match_team_info.dart';
import 'package:tracket/utils/constants/enums.dart';

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
  MatchTeamInfo challengedTeam;
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
        'matchType': matchType.name,
      };

  factory ChallengeMatch.fromMap(
    Map<String, dynamic> map, {
    List<QueryDocumentSnapshot>? challengerPlayer,
    List<QueryDocumentSnapshot>? challengedPlayer,
  }) =>
      ChallengeMatch(
        challengedTeam: MatchTeamInfo.fromMap(map['challengedTeam']),
        challengerId: map['challengerId'] as String,
        challengerName: map['challengerName'] as String,
        challengerTeam: MatchTeamInfo.fromMap(map['challengerTeam']),
        updatedAt: map['updatedAt'] as Timestamp,
        allowSpectator: map['allowSpectator'] as bool,
        challengedPlayers: challengedPlayer
                ?.map((doc) =>
                    MatchPlayerInfo.fromMap(doc.data() as Map<String, dynamic>))
                .toList() ??
            [],
        challengerPlayers: challengerPlayer
                ?.map((doc) =>
                    MatchPlayerInfo.fromMap(doc.data() as Map<String, dynamic>))
                .toList() ??
            [],
        noOfPlayers: map['noOfPlayers'] as int,
        overs: Match.getMatchFormat(map['overs'] as String),
        venue: map['venue'] as String,
        schedule: (map['schedule'] as Timestamp).toDate(),
        matchType: Match.getMatchType(map['matchType'] as String),
      );

  ChallengeMatch copyWith({
    MatchTeamInfo? challengerTeam,
    MatchTeamInfo? challengedTeam,
    String? challengerId,
    String? challengerName,
    MatchFormat? overs,
    String? venue,
    DateTime? schedule,
    bool? allowSpectator,
    Timestamp? updatedAt,
    int? noOfPlayers,
    MatchType? matchType,
    List<MatchPlayerInfo>? challengerPlayers,
    List<MatchPlayerInfo>? challengedPlayers,
  }) =>
      ChallengeMatch(
        challengerTeam: challengerTeam ?? this.challengerTeam,
        challengedTeam: challengedTeam ?? this.challengedTeam,
        challengerId: challengerId ?? this.challengerId,
        challengerName: challengerName ?? this.challengerName,
        overs: overs ?? this.overs,
        venue: venue ?? this.venue,
        schedule: schedule ?? this.schedule,
        allowSpectator: allowSpectator ?? this.allowSpectator,
        updatedAt: updatedAt ?? this.updatedAt,
        noOfPlayers: noOfPlayers ?? this.noOfPlayers,
        matchType: matchType ?? this.matchType,
        challengerPlayers: challengerPlayers ?? this.challengerPlayers,
        challengedPlayers: challengedPlayers ?? this.challengedPlayers,
      );

  void setChallengerPlayers(List<MatchPlayerInfo> players) {
    challengerPlayers = players;
  }

  void setChallengedPlayers(List<MatchPlayerInfo> players) {
    challengedPlayers = players;
  }

  void updateTeamDetails({
    required String captainId,
    required String wicketkeeperId,
  }) {
    challengedTeam = challengedTeam.copyWith(
      captainId: captainId,
      wicketkeeperId: wicketkeeperId,
    );
  }
}
