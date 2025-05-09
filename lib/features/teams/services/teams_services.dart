import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/players/models/player_details.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/features/teams/models/team.dart';
import 'package:tracket/features/teams/models/team_details.dart';
import 'package:tracket/features/teams/models/team_stats.dart';
import 'package:tracket/features/teams/providers/providers.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/firestore_collections.dart';

class TeamsServices {
  static final _firestore = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> getTeamData(String teamId) async {
    final teamSnap = await _firestore.collection(FirestoreCollections.teams).doc(teamId).get();

    return teamSnap.data()!;
  }

  static Future<String> createTeam({
    required String teamId,
    required String teamName,
    required String shortName,
    required String logoUrl,
    required String createdBy,
    required String adminName,
    required CricketRole adminCricketRole,
    required String longCricketRole,
    required String description,
    required bool isPrivate,
    required int maxPlayers,
    String adminImageUrl = '',
    required WidgetRef ref,
  }) async {
    String result;

    try {
      final team = Team(
        name: teamName,
        shortName: shortName,
        logoUrl: logoUrl,
        playersList: [],
        createdBy: createdBy,
        id: teamId,
        achievements: [],
        followers: [],
        requestedPlayers: [],
        challengedTeams: [],
        playerIds: [createdBy],
        description: description,
        isPrivate: isPrivate,
      );
      await _firestore.collection(FirestoreCollections.teams).doc(team.id).set(team.toJson());

      final teamStatsCollectionRef =
          _firestore.collection(FirestoreCollections.teams).doc(team.id).collection(FirestoreCollections.stats);

      final initialStats = const TeamStats();

      await teamStatsCollectionRef.doc(TTextStrings.over5Key).set(initialStats.toJson());
      await teamStatsCollectionRef.doc(TTextStrings.over10Key).set(initialStats.toJson());
      await teamStatsCollectionRef.doc(TTextStrings.over20Key).set(initialStats.toJson());
      await teamStatsCollectionRef.doc(TTextStrings.over50Key).set(initialStats.toJson());
      await teamStatsCollectionRef.doc(TTextStrings.testKey).set(initialStats.toJson());

      final playerInfo = PlayerDetails(
          cricketRole: adminCricketRole,
          id: createdBy,
          imageUrl: adminImageUrl,
          name: adminName,
          role: TeamRole.owner,
          longCricketRole: longCricketRole);

      await _firestore
          .collection(FirestoreCollections.teams)
          .doc(team.id)
          .collection(FirestoreCollections.teamPlayers)
          .doc(createdBy)
          .set(playerInfo.toMap);

      final teamInfo = TeamDetails(
        id: team.id,
        logoUrl: logoUrl,
        name: teamName,
        shortName: shortName,
        role: TeamRole.owner,
      );

      await _firestore
          .collection(FirestoreCollections.players)
          .doc(createdBy)
          .collection(FirestoreCollections.playerTeams)
          .doc(team.id)
          .set(teamInfo.toMap);

      ref.read(playerProvider.notifier).addTeam(teamInfo);
      result = TTextStrings.success;
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  static Future<void> deletePlayerFromTeam(
    String playerId,
    WidgetRef ref,
    BuildContext context,
  ) async {
    final teamState = ref.read(teamProvider);
    try {
      //* Update team's player list in database
      await _firestore
          .collection(FirestoreCollections.teams)
          .doc(teamState.team.id)
          .collection(FirestoreCollections.teamPlayers)
          .doc(playerId)
          .delete();
      ref.read(teamProvider.notifier).deletePlayer(playerId);
      _firestore.collection(FirestoreCollections.teams).doc(teamState.team.id).update({
        'playersIds': FieldValue.arrayRemove([playerId]),
      });
      if (teamState.team.captainId == playerId) {
        await _firestore.collection(FirestoreCollections.teams).doc(teamState.team.id).update({'captainId': ''});
        ref.read(teamProvider.notifier).updateField(captainId: '');
      }
      if (teamState.team.wicketkeeperId == playerId) {
        await _firestore.collection(FirestoreCollections.teams).doc(teamState.team.id).update({'wicketkeeperId': ''});
        ref.read(teamProvider.notifier).updateField(wicketkeeperId: '');
      }

      //* Update player's team list in database
      _firestore
          .collection(FirestoreCollections.players)
          .doc(playerId)
          .collection(FirestoreCollections.playerTeams)
          .doc(teamState.team.id)
          .delete();
      if (playerId == ref.read(playerProvider).id) {
        ref.read(playerProvider.notifier).deleteTeam(teamState.team.id);
      }
    } catch (e) {
      if (context.mounted) {
        THelperFunction.showSnackBar(TTextStrings.failedToDeletePlayerMessage, context);
      }
    }
  }

  static Future<void> addPlayerToTeam({
    required PlayerDetails playerInfo,
    required TeamDetails teamInfo,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      //* Update player's team list in database
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.players)
          .doc(playerInfo.id)
          .collection(FirestoreCollections.playerTeams)
          .doc(teamInfo.id)
          .set(teamInfo.toMap);

      //* Update team's player list in state
      ref.read(teamProvider.notifier).addPlayer(playerInfo);
      _firestore.collection(FirestoreCollections.teams).doc(teamInfo.id).update({
        'playersIds': FieldValue.arrayUnion([playerInfo.id]),
      });

      //* Update team's player list in database
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.teams)
          .doc(teamInfo.id)
          .collection(FirestoreCollections.teamPlayers)
          .doc(playerInfo.id)
          .set(playerInfo.toMap);
      final currentPlayerId = ref.read(playerProvider).id;
      if (currentPlayerId == playerInfo.id) {
        ref.read(playerProvider.notifier).addTeam(teamInfo);
      }
    } catch (error) {
      if (context.mounted) {
        THelperFunction.showSnackBar(TTextStrings.failedToAddPlayerMessage, context);
      }
    }
  }

  static Future<void> updateTeamField(
    BuildContext context, {
    required String teamId,
    required String? teamName,
    required String? shortName,
    required String? description,
    required int maxPlayersCapacity,
    required String? captainId,
    required String? wicketkeeperId,
    required String? logoUrl,
  }) async {
    final Map<String, dynamic> updatedFields = {};
    if (teamName != null) updatedFields['name'] = teamName;
    if (shortName != null) updatedFields['shortName'] = shortName;
    if (description != null) updatedFields['description'] = description;
    updatedFields['maxPlayersCapacity'] = maxPlayersCapacity;
    if (captainId != null) updatedFields['captainId'] = captainId;
    if (wicketkeeperId != null) {
      updatedFields['wicketkeeperId'] = wicketkeeperId;
    }
    if (logoUrl != null) updatedFields['logoUrl'] = logoUrl;

    try {
      await _firestore.collection(FirestoreCollections.teams).doc(teamId).update(updatedFields);
    } catch (e) {
      if (context.mounted) {
        THelperFunction.showSnackBar(TTextStrings.failedToUpdateTeamMessage, context);
      }
    }
  }

  static Future<void> updateTeamPrivacy(
    BuildContext context, {
    required String teamId,
    required bool isPrivate,
  }) async {
    try {
      await _firestore.collection(FirestoreCollections.teams).doc(teamId).update({'isPrivate': isPrivate});
    } catch (e) {
      if (context.mounted) {
        THelperFunction.showSnackBar(TTextStrings.failedToUpdateTeamPrivacyMessage, context);
      }
    }
  }

  static Future<List<QueryDocumentSnapshot<Object?>>> getTeamPlayersFromId(String teamId, BuildContext context) async {
    List<QueryDocumentSnapshot<Object?>> teamPlayers = [];
    try {
      final teamPlayerSnap = await _firestore
          .collection(FirestoreCollections.teams)
          .doc(teamId)
          .collection(FirestoreCollections.teamPlayers)
          .get();

      teamPlayers = teamPlayerSnap.docs;
    } catch (e) {
      if (context.mounted) {
        THelperFunction.showSnackBar(TTextStrings.unableToFetchTeamData, context);
      }
    }

    return teamPlayers;
  }

  static void deleteTeam(BuildContext context, String teamId) async {
    try {
      await _firestore.collection(FirestoreCollections.teams).doc(teamId).delete();
    } catch (e) {
      if (context.mounted) {
        THelperFunction.showSnackBar(TTextStrings.failedToDeleteTeamMessage, context);
      }
    }
  }

  static Future<void> followTeam(
      String teamId, String playerId, bool isFollow, WidgetRef ref, BuildContext context) async {
    try {
      await _firestore.collection(FirestoreCollections.teams).doc(teamId).update({
        'followers': isFollow ? FieldValue.arrayUnion([playerId]) : FieldValue.arrayRemove([playerId])
      });

      final followers = ref.read(teamProvider).team.followers;
      isFollow ? followers.add(playerId) : followers.remove(playerId);

      ref.read(teamProvider.notifier).updateField(followers: followers);

      await _firestore.collection(FirestoreCollections.players).doc(playerId).update({
        'followingTeams': isFollow ? FieldValue.arrayUnion([teamId]) : FieldValue.arrayRemove([teamId])
      });
      final followingTeam = ref.read(playerProvider).followingTeams;
      isFollow ? followingTeam.add(teamId) : followingTeam.remove(teamId);

      ref.read(playerProvider.notifier).updateField(followingTeams: followingTeam);
    } catch (e) {
      if (context.mounted) {
        THelperFunction.showSnackBar(e.toString(), context);
      }
    }
  }

  static Future<void> updateRequestedPlayers({
    required String playerId,
    required String teamId,
    required bool isAdding,
  }) async {
    await _firestore.collection(FirestoreCollections.teams).doc(teamId).update({
      'requestedPlayers': isAdding ? FieldValue.arrayUnion([playerId]) : FieldValue.arrayRemove([playerId])
    });
  }

  static Future<void> updateChallengedTeams({
    required String teamId,
    required String challengedTeamId,
    required bool isAdding,
  }) async {
    await _firestore.collection(FirestoreCollections.teams).doc(teamId).update({
      'challengedTeams':
          isAdding ? FieldValue.arrayUnion([challengedTeamId]) : FieldValue.arrayRemove([challengedTeamId])
    });
  }

  static Future<List> getTeamChallengedList(String teamId) async {
    final teamChallengedSnap = await _firestore.collection(FirestoreCollections.teams).doc(teamId).get();

    return teamChallengedSnap.data()!['challengedTeams'];
  }
}
