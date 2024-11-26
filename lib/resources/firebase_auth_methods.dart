import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracket/models/player.dart';
import 'package:tracket/models/user.dart' as model;
import 'package:uuid/uuid.dart';

class FirebaseAuthMethods {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static const uuid = Uuid();

  static Future<String> signupUser({
    required String username,
    required String email,
    required String password,
  }) async {
    String result;

    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final model.User user = model.User(
        email: email,
        username: username,
        role: 'user',
        createdAt: Timestamp.now(),
        userId: userCred.user!.uid,
      );

      await _firestore
          .collection('users')
          .doc(userCred.user!.uid)
          .set(user.toJson);
      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  static Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String result;
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  static Future<String> signupPlayer({
    required String playerName,
    required String email,
    required String password,
    required CricketRole cricketRole,
    required Position battingPosition,
    required BowingStyle bowlingStyle,
    Position? bowlingArm,
  }) async {
    String result;

    try {
      final playerCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String playerId = playerCred.user!.uid;

      final player = Player(
        playerName: playerName,
        email: email,
        role: cricketRole,
        battingPosition: battingPosition,
        bowlingArm: bowlingArm,
        bowlingStyle: bowlingStyle,
        createdAt: Timestamp.now(),
        id: playerId,
      );
      await _firestore.collection('players').doc(playerId).set(player.toJson);

      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  static Future<String> loginPlayer({
    required String email,
    required String password,
  }) async {
    String result;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  Future<void> sendEmailVarification(String email) async {
    final actionCodeSettings = ActionCodeSettings(
      url: 'https://flutter-cricket-stats-manager.page.link/verifyEmail',
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ios',
      androidPackageName: 'com.example.android',
      androidInstallApp: true,
      androidMinimumVersion: '12',
    );

    await _auth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: actionCodeSettings,
    );
  }

  Future<bool> checkEmailVarification(String email, String link) async {
    if (_auth.isSignInWithEmailLink(link)) {
      try {
        _auth.signInWithEmailLink(email: email, emailLink: link);
        print('email varified successfully');
        return true;
      } catch (error) {
        print("Error verifying email: $error");
        return false;
      }
    }
    return false;
  }
}
