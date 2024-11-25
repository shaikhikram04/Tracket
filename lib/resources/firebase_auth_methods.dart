import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}
