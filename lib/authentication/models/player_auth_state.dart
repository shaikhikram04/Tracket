import 'package:flutter/material.dart';
import 'package:tracket/players/models/player.dart';

class PlayerAuthState {
  final GlobalKey<FormState> formKey;
  final String? playerName;
  final String? email;
  final String? password;
  final bool isPasswordHidden;
  final bool isLogin;
  final bool isBowler;
  final CricketRole? cricketRole;
  final Position? battingPosition;
  final BowlingStyle? bowlingStyle;
  final Position? bowlingArm;
  final bool isLoading;

  const PlayerAuthState({
    required this.formKey,
    this.playerName,
    this.email,
    this.password,
    this.isPasswordHidden = true,
    this.isLogin = true,
    this.isBowler = false,
    this.cricketRole,
    this.battingPosition,
    this.bowlingStyle,
    this.bowlingArm,
    this.isLoading = false,
  });

  PlayerAuthState copyWith({
    GlobalKey<FormState>? formKey,
    String? playerName,
    String? email,
    String? password,
    bool? isPasswordHidden,
    bool? isLogin,
    bool? isBowler,
    CricketRole? cricketRole,
    Position? battingPosition,
    BowlingStyle? bowlingStyle,
    Position? bowlingArm,
    bool? isLoading,
  }) {
    return PlayerAuthState(
      formKey: formKey ?? this.formKey,
      playerName: playerName ?? this.playerName,
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isLogin: isLogin ?? this.isLogin,
      isBowler: isBowler ?? this.isBowler,
      cricketRole: cricketRole ?? this.cricketRole,
      battingPosition: battingPosition ?? this.battingPosition,
      bowlingStyle: bowlingStyle ?? this.bowlingStyle,
      bowlingArm: bowlingArm ?? this.bowlingArm,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
