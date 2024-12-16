import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/models/team.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  static final _firestore = FirebaseFirestore.instance;
  static const uuid = Uuid();

  static Future<String> createTeam({
    required String teamName,
    required String shortName,
    required String? logoUrl,
    required String createdBy,
  }) async {
    String result;

    try {
      final team = Team(
        name: teamName,
        shortName: shortName,
        logoUrl: logoUrl,
        playersList: [],
        createdBy: createdBy,
        id: uuid.v4(),
      );
      await _firestore.collection('teams').doc(team.id).set(team.toJson);
      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }
}
