import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.email,
    required this.username,
    required this.role,
    required this.createdAt,
  });

  final String email;
  final String username;
  final String role;
  final Timestamp createdAt;
}
