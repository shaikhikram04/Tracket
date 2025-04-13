import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/features/notifications/models/challenge_match.dart';
import 'package:tracket/features/notifications/models/follow_data.dart';
import 'package:tracket/features/players/models/player_details.dart';
import 'package:tracket/features/teams/models/team_details.dart';

enum NotificationType {
  follow,
  teamJoinRequest, //* player request to join team
  offerPlayerRequest, //* team offer player to join team
  matchChallenge,
}

enum NotificationStatus {
  pending,
  accept,
  reject;

  bool get isPending => this == NotificationStatus.pending;
  bool get isAccepted => this == NotificationStatus.accept;
  bool get isReject => this == NotificationStatus.reject;
}

class NotificationModel {
  const NotificationModel({
    required this.notificationId,
    required this.from,
    required this.to,
    required this.type,
    required this.createdAt,
    required this.status,
    required this.read,
    required this.followerData,
    required this.teamDetails,
    required this.playerDetails,
    required this.challengeMatch,
  });

  factory NotificationModel.request({
    required String notificationId,
    required String from,
    required String to,
    required NotificationType type,
    required Timestamp createdAt,
    required NotificationStatus status,
    required bool read,
    required TeamDetails? teamDetails,
    required PlayerDetails? playerDetails,
  }) =>
      NotificationModel(
        notificationId: notificationId,
        from: from,
        to: to,
        type: type,
        createdAt: createdAt,
        status: status,
        read: read,
        teamDetails: teamDetails,
        playerDetails: playerDetails,
        challengeMatch: null,
        followerData: null,
      );

  factory NotificationModel.challenge({
    required String notificationId,
    required String from,
    required String to,
    required Timestamp createdAt,
    required NotificationStatus status,
    required bool read,
    required ChallengeMatch challengeMatch,
  }) =>
      NotificationModel(
        notificationId: notificationId,
        from: from,
        to: to,
        type: NotificationType.matchChallenge,
        createdAt: createdAt,
        status: status,
        read: read,
        challengeMatch: challengeMatch,
        followerData: null,
        playerDetails: null,
        teamDetails: null,
      );

  factory NotificationModel.follow({
    required String notificationId,
    required String from,
    required String to,
    required Timestamp createdAt,
    required NotificationStatus status,
    required bool read,
    required FollowerData followerData,
  }) =>
      NotificationModel(
        notificationId: notificationId,
        from: from,
        to: to,
        type: NotificationType.follow,
        createdAt: createdAt,
        status: status,
        read: read,
        followerData: followerData,
        challengeMatch: null,
        playerDetails: null,
        teamDetails: null,
      );

  //* common field
  final String notificationId;
  final String from;
  final String to;
  final NotificationType type;
  final Timestamp createdAt;
  final NotificationStatus status;
  final bool read;

  //! Type specific field
  //* for follow
  final FollowerData? followerData;

  //* for teamJoinRequest
  final TeamDetails? teamDetails;

  //* for addPlayerRequest
  final PlayerDetails? playerDetails;

  //* for challengeMatch
  final ChallengeMatch? challengeMatch;

  Map<String, dynamic> get toMap => {
        'notificationId': notificationId,
        'from': from,
        'to': to,
        'type': type.name,
        'createdAt': createdAt,
        'status': status.name,
        'read': read,
        'followerData': followerData,
        'teamDetail': teamDetails?.toMap,
        'playerDetail': playerDetails?.toMap,
        'challengeMatch': challengeMatch?.toMap,
      };

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    final type = NotificationType.values.firstWhere(
      (e) => e.name == map['type'],
      orElse: () => NotificationType.offerPlayerRequest,
    );

    final status = NotificationStatus.values.firstWhere(
      (e) => e.name == map['status'],
      orElse: () => NotificationStatus.pending,
    );

    if (type == NotificationType.offerPlayerRequest ||
        type == NotificationType.teamJoinRequest) {
      return NotificationModel.request(
        notificationId: map['notificationId'],
        from: map['from'],
        to: map['to'],
        type: type,
        createdAt: map['createdAt'],
        status: status,
        read: map['read'],
        teamDetails: TeamDetails.formMap(map['teamDetail']),
        playerDetails: PlayerDetails.fromMap(map['playerDetail']),
      );
    } else if (type == NotificationType.matchChallenge) {
      return NotificationModel.challenge(
        notificationId: map['notificationId'],
        from: map['from'],
        to: map['to'],
        createdAt: map['createdAt'],
        status: status,
        read: map['read'],
        challengeMatch: ChallengeMatch.fromMap(
          map['challengeMatch'],
          challengerPlayer: [],
          challengedPlayer: [],
        ),
      );
    } else {
      return NotificationModel(
        notificationId: map['notificationId'],
        from: map['from'],
        to: map['to'],
        type: type,
        createdAt: map['createdAt'],
        status: status,
        read: map['read'],
        followerData: FollowerData.fromMap(map['followerData']),
        teamDetails: TeamDetails.formMap(map['teamDetail']),
        playerDetails: PlayerDetails.fromMap(map['playerDetail']),
        challengeMatch: ChallengeMatch.fromMap(
          map,
          challengerPlayer: [],
          challengedPlayer: [],
        ),
      );
    }
  }

  bool get isPending => status == NotificationStatus.pending;
  bool get isAccepted => status == NotificationStatus.accept;
  bool get isRejected => status == NotificationStatus.reject;

  bool get isFollow => type == NotificationType.follow;
  bool get isChallenge => type == NotificationType.matchChallenge;
  bool get isRequest =>
      type == NotificationType.offerPlayerRequest ||
      type == NotificationType.teamJoinRequest;
}
