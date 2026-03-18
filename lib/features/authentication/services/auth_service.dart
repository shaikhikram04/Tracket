// Base authentication service
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthService {
  User get currentUser;
  String get currentUserId;
  Future<User?> sendVerificationEmail(
    String email,
    String password,
  );
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
    required Ref ref,
    required String expectedRole,
  });
  Future<void> logout();
  Future<void> deleteCurrentAccount();
  Future<String> resetPassword(String email);
}
