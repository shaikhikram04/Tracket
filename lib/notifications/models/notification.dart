import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/matches/models/challenge_match.dart';
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

class FollowerData {
  FollowerData({
    required this.followerId,
    required this.profilePic,
    required this.userName,
  });

  final String followerId;
  final String profilePic;
  final String userName;
}

class Notification {
  Notification({
    required this.notificationId,
    required this.from,
    required this.to,
    required this.type,
    required this.createdAt,
    required this.challengeStatus,
    required this.read,
    required this.title,
    required this.body,
    required this.followerData,
    required this.teamDetails,
    required this.playerDetails,
    required this.challengeMatch,
  });

  //* common field
  final String notificationId;
  final String from;
  final String to;
  final NotificationType type;
  final Timestamp createdAt;
  final NotificationStatus challengeStatus;
  final bool read;

  //* metaData
  final String title;
  final String body;

  //! Type specific field
  //* for follow
  final FollowerData followerData;

  //* for teamJoinRequest
  final TeamDetails teamDetails;

  //* for addPlayerRequest
  final PlayerDetails playerDetails;

  //* for challengeMatch
  final ChallengeMatch challengeMatch;
}
