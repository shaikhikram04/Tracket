import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.userId,
    required this.email,
    required this.username,
    required this.role,
    required this.createdAt,
  });

  final String userId;
  final String email;
  final String username;
  final String role;
  final Timestamp createdAt;

  Map<String, dynamic> get toJson => {
        'userId': userId,
        'email': email,
        'username': username,
        'role': role,
        'createdAt': createdAt,
      };
}
