import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/models/player.dart';
import 'package:tracket/models/player_stats.dart';

class PlayerNotifier extends StateNotifier<Player> {
  PlayerNotifier()
      : super(Player(
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
          teamsId: [],
          bestBalling: null,
          playerStats: null,
          matchesPlayed: null,
        ));

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
    String? teamId,
    PlayerStats? playerStats,
    int? matchesPlayed,
  }) {
    final teamList = state.teamsId;
    if (teamId != null && teamList != null) teamList.add(teamId);

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
      teamsId: teamList,
      bestBalling: bestBalling ?? state.bestBalling,
      playerStats: playerStats ?? state.playerStats,
      matchesPlayed: matchesPlayed ?? state.matchesPlayed,
    );

    state = player;
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, Player>(
  (ref) => PlayerNotifier(),
);
