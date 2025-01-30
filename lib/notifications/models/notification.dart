import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/notifications/models/challenge_match.dart';
import 'package:tracket/notifications/models/follow_data.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team_details.dart';

enum NotificationType {
  follow,
  teamJoinRequest, //* player request to join team
  offerPlayerRequest, //* team offer player to join team
  matchChallenge,
}

enum NotificationStatus {
  pending,
  accept,
  decline,
}

class Notification {
  const Notification({
    required this.notificationId,
    required this.from,
    required this.to,
    required this.type,
    required this.createdAt,
    required this.status,
    required this.read,
    required this.title,
    required this.body,
    required this.followerData,
    required this.teamDetails,
    required this.playerDetails,
    required this.challengeMatch,
  });

  factory Notification.request({
    required String notificationId,
    required String from,
    required String to,
    required NotificationType type,
    required Timestamp createdAt,
    required NotificationStatus status,
    required bool read,
    required String title,
    required String body,
    required TeamDetails? teamDetails,
    required PlayerDetails? playerDetails,
  }) =>
      Notification(
        notificationId: notificationId,
        from: from,
        to: to,
        type: type,
        createdAt: createdAt,
        status: status,
        read: read,
        title: title,
        body: body,
        teamDetails: teamDetails,
        playerDetails: playerDetails,
        challengeMatch: null,
        followerData: null,
      );

  factory Notification.challenge({
    required String notificationId,
    required String from,
    required String to,
    required Timestamp createdAt,
    required NotificationStatus status,
    required bool read,
    required String title,
    required String body,
    required ChallengeMatch challengeMatch,
  }) =>
      Notification(
        notificationId: notificationId,
        from: from,
        to: to,
        type: NotificationType.matchChallenge,
        createdAt: createdAt,
        status: status,
        read: read,
        title: title,
        body: body,
        challengeMatch: challengeMatch,
        followerData: null,
        playerDetails: null,
        teamDetails: null,
      );

  factory Notification.follow({
    required String notificationId,
    required String from,
    required String to,
    required Timestamp createdAt,
    required NotificationStatus status,
    required bool read,
    required String title,
    required String body,
    required FollowerData followerData,
  }) =>
      Notification(
        notificationId: notificationId,
        from: from,
        to: to,
        type: NotificationType.follow,
        createdAt: createdAt,
        status: status,
        read: read,
        title: title,
        body: body,
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

  //* metaData
  final String title;
  final String body;

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
        'title': title,
        'body': body,
        'followerData': followerData,
        'teamDetail': teamDetails?.toMap,
        'playerDetail': playerDetails?.toMap,
        'challengeMatch': challengeMatch?.toMap,
      };

  // static NotificationType getType(String strType) {
  //   for (final nType in NotificationType.values) {
  //     if (strType == nType.name) return nType;
  //   }

  //   return NotificationType.offerPlayerRequest;
  // }

  // static NotificationStatus getStatus(String strStatus) {
  //   for (final nStatus in NotificationStatus.values) {
  //     if (strStatus == nStatus.name) return nStatus;
  //   }

  //   return NotificationStatus.pending;
  // }

  factory Notification.fromMap(Map<String, dynamic> map) {
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
      return Notification.request(
        notificationId: map['notificationId'],
        from: map['from'],
        to: map['to'],
        type: type,
        createdAt: map['createdAt'],
        status: status,
        read: map['read'],
        title: map['title'],
        body: map['body'],
        teamDetails: TeamDetails.formMap(map['teamDetail']),
        playerDetails: PlayerDetails.fromMap(map['playerDetail']),
      );
    } else if (type == NotificationType.matchChallenge) {
      return Notification.challenge(
        notificationId: map['notificationId'],
        from: map['from'],
        to: map['to'],
        createdAt: map['createdAt'],
        status: status,
        read: map['read'],
        title: map['title'],
        body: map['body'],
        challengeMatch: ChallengeMatch.fromMap(
          map['challengeMatch'],
          challengerPlayer: [],
          challengedPlayer: [],
        ),
      );
    } else {
      return Notification(
        notificationId: map['notificationId'],
        from: map['from'],
        to: map['to'],
        type: type,
        createdAt: map['createdAt'],
        status: status,
        read: map['read'],
        title: map['title'],
        body: map['body'],
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
  bool get isDeclined => status == NotificationStatus.decline;

  bool get isFollow => type == NotificationType.follow;
  bool get isChallenge => type == NotificationType.matchChallenge;
  bool get isRequest =>
      type == NotificationType.offerPlayerRequest ||
      type == NotificationType.teamJoinRequest;
}
