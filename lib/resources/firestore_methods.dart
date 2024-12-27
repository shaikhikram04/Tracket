import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/resources/firestore_collections.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  static final _firestore = FirebaseFirestore.instance;
  static const uuid = Uuid();

  static Future<String> createTeam({
    required String teamName,
    required String shortName,
    required String? logoUrl,
    required String createdBy,
    required String adminName,
    required String adminCricketRole,
    String? adminImageUrl,
  }) async {
    String result;

    try {
      final team = Team(
        name: teamName,
        shortName: shortName,
        logoUrl: logoUrl,
        playersList: [
          {
            'id': createdBy,
            'name': adminName,
            'cricketRole': adminCricketRole,
            'imageUrl': adminImageUrl,
          }
        ],
        createdBy: createdBy,
        id: uuid.v4(),
        achievements: [],
        following: [],
        followers: [],
      );
      await _firestore
          .collection(FirestoreCollections.teams)
          .doc(team.id)
          .set(team.toJson);
      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  static Future<Player> getPlayerFromId(String playerId) async {
    Player player;

    final fetchedData = await _firestore
        .collection(FirestoreCollections.teams)
        .doc(playerId)
        .get();
    player = Player.fromSeed(fetchedData.data()!);

    return player;
  }

  static Future<void> deletePlayerFromTeam(
    Map<String, dynamic> playerInfo,
    String teamId,
  ) async {
    await _firestore.collection(FirestoreCollections.teams).doc(teamId).update({
      'playersList': FieldValue.arrayRemove([
        {
          'id': playerInfo['id'],
          'cricketRole': playerInfo['cricketRole'],
          'imageUrl': playerInfo['imageUrl'],
          'name': playerInfo['name'],
        }
      ])
    });
  }
}
