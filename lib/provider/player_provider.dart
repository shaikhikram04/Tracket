import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/models/player.dart';

class PlayerNotifier extends StateNotifier<Player> {
  PlayerNotifier(super.state);

  void setPlayer(Player player) {
    state = player;
  }

  void updateField({
    String? id,
    String? email,
    String? name,
    String? role,
    String? profileImageUrl,
    CricketRole? cricketRole,
    Position? battingPosition,
    int? totalTimesOut,
    BowlingFigure? bestBalling,
    Position? bowlingArm,
    BowlingStyle? bowlingStyle,
  }) {
    final player = Player(
      role: role ?? state.role,
      id: id ?? state.id,
      name: name ?? state.name,
      email: email ?? state.email,
      profileImageUrl: profileImageUrl ?? state.profileImageUrl,
      cricketRole: cricketRole ?? state.cricketRole,
      battingPosition: battingPosition ?? state.battingPosition,
      bowlingArm: bowlingArm ?? state.bowlingArm,
      bowlingStyle: bowlingStyle ?? state.bowlingStyle,
      createdAt: state.createdAt,
      totalTimesOut: totalTimesOut ?? state.totalTimesOut,
      
    );
    if (bestBalling != null) {
      player.bestBalling = bestBalling;
    }

    state = player;
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, Player>(
  (ref) => PlayerNotifier(
    Player(
      role: '',
      id: '',
      name: '',
      email: '',
      profileImageUrl: null,
      cricketRole: null,
      battingPosition: null,
      bowlingArm: null,
      bowlingStyle: null,
      createdAt: Timestamp.now(),
    ),
  ),
);
