import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracket/models/player.dart';
import 'package:tracket/models/user.dart' as model;
import 'package:uuid/uuid.dart';

class FirebaseAuthMethods {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static const uuid = Uuid();

  static User get currentUser => _auth.currentUser!;

  static Future<User?> sendVerificationEmail(
    String email,
    String password,
  ) async {
    User? user;
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCred.user;
      await user?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw FirebaseAuthException(
          code: 'Email-is-already-in-use',
          message: 'Try another email or login with this email.',
        );
      }
    }

    return user;
  }

  static Future<String> signupUser({
    required String userId,
    required String username,
    required String email,
  }) async {
    String result;

    try {
      final model.User user = model.User(
        email: email,
        username: username,
        role: 'user',
        createdAt: Timestamp.now(),
        userId: userId,
      );

      await _firestore.collection('users').doc(userId).set(user.toJson);
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
}
