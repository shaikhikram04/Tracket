import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';

enum ChallengeStatus {
  pending,
  accept,
  decline;

  bool get isPending => this == ChallengeStatus.pending;
  bool get isAccepted => this == ChallengeStatus.accept;
  bool get isDeclined => this == ChallengeStatus.decline;
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
    required this.status,
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
  final ChallengeStatus status;
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
        'status': status.name
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
        status: map['status'],
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
    ChallengeStatus? status,
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
        status: status ?? this.status,
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
