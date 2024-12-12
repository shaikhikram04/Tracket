import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/models/team.dart';

class FirestoreMethods {
  static final _firestore = FirebaseFirestore.instance;

  Future<String> uploadTeamData({
    required String teamName,
    required String shortName,
    String? logoUrl,
    required String createdBy,
  }) async {
    String result;

    try {
      final team = Team(
        name: teamName,
        shortName: shortName,
        logoUrl: logoUrl,
        playersList: [],
        captainId: '',
        wicketKeeperId: '',
        createdBy: createdBy,
      );
      await _firestore.collection('teams').doc(team.id).set(team.toJson);
      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }
}
