import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/notifications/models/challenge_match.dart';
import 'package:tracket/notifications/models/follow_data.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team_details.dart';

enum NotificationType {
  follow,
  teamJoinRequest,
  addPlayerRequest,
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
        'type': type,
        'createdAt': createdAt,
        'status': status,
        'read': read,
        'title': title,
        'body': body,
        'followerData': followerData,
        'teamDetail': teamDetails?.toMap,
        'playerDetail': playerDetails?.toMap,
        'challengeMatch': challengeMatch?.toMap,
      };
}
