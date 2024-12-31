import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/models/player_stats.dart';

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
          teams: [],
          playerStats: null,
          achievements: [],
          following: [],
          followers: [],
          allowDirectTeamAdd: null,
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
    List<Map<String, dynamic>>? teams,
    PlayerStats? playerStats,
    int? matchesPlayed,
    List<String>? achievements,
    List<String>? following,
    List<String>? followers,
    bool? allowDirectTeamAdd,
    int? innings,
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
      teams: teams ?? state.teams,
      playerStats: playerStats ?? state.playerStats,
      achievements: achievements ?? state.achievements,
      following: following ?? state.following,
      followers: followers ?? state.followers,
      allowDirectTeamAdd: allowDirectTeamAdd ?? state.allowDirectTeamAdd,
    );

    state = player;
  }

  void addTeam(Map<String, dynamic> teamInfo) {
    final updatedTeams = [...state.teams!, teamInfo];
    updateField(teams: updatedTeams);
  }

  void deleteTeam(String teamId) {
    final updatedTeams =
        state.teams!.where((team) => team['id'] != teamId).toList();
    updateField(teams: updatedTeams);
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, Player>(
  (ref) => PlayerNotifier(),
);
