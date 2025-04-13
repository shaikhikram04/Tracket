import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/players/models/player_cricket_detail.dart';

class VerificationData {
  VerificationData({
    required this.user,
    required this.username,
    required this.imageUrl,
    required this.ref,
    required this.context,
    required this.role,
    this.cricketRole,
    this.battingPosition,
    this.bowlingStyle,
    this.bowlingArm,
  });

  final User user;
  final String username;
  final String imageUrl;
  final Ref ref;
  final BuildContext context;
  final String role;
  final CricketRole? cricketRole;
  final Position? battingPosition;
  final BowlingStyle? bowlingStyle;
  final Position? bowlingArm;
}
