// Base authentication service
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  User get currentUser;
  String get currentUserId;

  Future<void> logout();
  Future<void> deleteCurrentAccount();
}
