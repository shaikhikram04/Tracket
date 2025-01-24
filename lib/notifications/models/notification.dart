import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/notifications/models/challenge_match.dart';
import 'package:tracket/notifications/models/follow_data.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team_details.dart';

enum NotificationType {
  follow,
  teamJoinRequest,    //* player request to join team
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

  Notification.request({
    required this.notificationId,
    required this.from,
    required this.to,
    required this.type,
    required this.createdAt,
    required this.status,
    required this.read,
    required this.title,
    required this.body,
    required this.teamDetails,
    required this.playerDetails,
  })  : challengeMatch = null,
        followerData = null;

  Notification.challenge({
    required this.notificationId,
    required this.from,
    required this.to,
    required this.type,
    required this.createdAt,
    required this.status,
    required this.read,
    required this.title,
    required this.body,
    required this.challengeMatch,
  })  : playerDetails = null,
        teamDetails = null,
        followerData = null;

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

  static NotificationType getType(String strType) {
    for (final nType in NotificationType.values) {
      if (strType == nType.name) return nType;
    }

    return NotificationType.offerPlayerRequest;
  }

  static NotificationStatus getStatus(String strStatus) {
    for (final nStatus in NotificationStatus.values) {
      if (strStatus == nStatus.name) return nStatus;
    }

    return NotificationStatus.pending;
  }

  static Notification fromMap(Map<String, dynamic> snap) {
    NotificationType type = getType(snap['type']);

    if (type == NotificationType.offerPlayerRequest ||
        type == NotificationType.teamJoinRequest) {
      return Notification.request(
        notificationId: snap['notificationId'],
        from: snap['from'],
        to: snap['to'],
        type: type,
        createdAt: snap['createdAt'],
        status: getStatus(snap['status']),
        read: snap['read'],
        title: snap['title'],
        body: snap['body'],
        teamDetails: snap['teamDetail'] == null
            ? null
            : TeamDetails.formMap(snap['teamDetail']),
        playerDetails: snap['playerDetail'] == null
            ? null
            : PlayerDetails.fromMap(snap['playerDetail']),
      );
    } else if (type == NotificationType.matchChallenge) {
      return Notification.challenge(
        notificationId: snap['notificationId'],
        from: snap['from'],
        to: snap['to'],
        type: type,
        createdAt: snap['createdAt'],
        status: getStatus(snap['status']),
        read: snap['read'],
        title: snap['title'],
        body: snap['body'],
        challengeMatch: ChallengeMatch.formMap(snap['challengeMatch'], [], []),
      );
    } else {
      return Notification(
        notificationId: snap['notificationId'],
        from: snap['from'],
        to: snap['to'],
        type: type,
        createdAt: snap['createdAt'],
        status: getStatus(snap['status']),
        read: snap['read'],
        title: snap['title'],
        body: snap['body'],
        followerData: FollowerData(
            followerId: snap['followerId'],
            profilePic: snap['profilePic'],
            userName: snap['userName']),
        teamDetails: snap['teamDetail'] == null
            ? null
            : TeamDetails.formMap(snap['teamDetail']),
        playerDetails: snap['playerDetail'] == null
            ? null
            : PlayerDetails.fromMap(snap['playerDetail']),
        challengeMatch: ChallengeMatch.formMap(snap, [], []),
      );
    }
  }
}
