import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/models/player.dart';
import 'package:tracket/players/models/player_cricket_detail.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/teams/models/team_role.dart';

class PlayerNotifier extends StateNotifier<Player> {
  PlayerNotifier()
      : super(Player(
          role: '',
          id: '',
          name: '',
          email: '',
          profileImageUrl: '',
          createdAt: Timestamp.now(),
          following: [],
          followingTeams: [],
          followers: [],
          playerCricketDetails: null,
        ));

  void setPlayer(Player player) {
    state = player;
  }

  void updateField({
    String? email,
    String? name,
    String? role,
    String? profileImageUrl,
    List? following,
    List? followingTeams,
    List? followers,
    PlayerCricketDetails? playerCricketDetails,
  }) {
    final player = Player(
      role: role ?? state.role,
      id: state.id,
      name: name ?? state.name,
      email: email ?? state.email,
      profileImageUrl: profileImageUrl ?? state.profileImageUrl,
      createdAt: state.createdAt,
      following: following ?? state.following,
      followingTeams: followingTeams ?? state.followingTeams,
      followers: followers ?? state.followers,
      playerCricketDetails: playerCricketDetails ?? state.playerCricketDetails,
    );

    state = player;
  }

  void updateRequestedTeam(String teamId, bool isAdding) {
    final updatedRequestedTeams = [
      ...state.playerCricketDetails!.requestedTeams
    ];
    if (isAdding) {
      updatedRequestedTeams.add(teamId);
    } else {
      updatedRequestedTeams.remove(teamId);
    }
    final updatedPlayerCricketDetail = state.playerCricketDetails!.copywith(
      requestedTeams: updatedRequestedTeams,
    );
    updateField(playerCricketDetails: updatedPlayerCricketDetail);
  }

  void addTeam(TeamDetails teamInfo) {
    final updatedTeams = [...state.playerCricketDetails!.teams, teamInfo];
    final updatedPlayerCricDetail =
        state.playerCricketDetails!.copywith(teams: updatedTeams);
    updateField(playerCricketDetails: updatedPlayerCricDetail);
  }

  void updateTeamRole(String teamId, TeamRole role) {
    final updatedTeams = state.playerCricketDetails!.teams.map((team) {
      if (team.id == teamId) {
        return team.copyWith(role: role);
      }
      return team;
    }).toList();
    final updatedPlayerCricDetail =
        state.playerCricketDetails!.copywith(teams: updatedTeams);
    updateField(playerCricketDetails: updatedPlayerCricDetail);
  }

  void deleteTeam(String teamId) {
    final updatedTeams = state.playerCricketDetails!.teams
        .where((team) => team.id != teamId)
        .toList();
    final updatedPlayerCricDetail =
        state.playerCricketDetails!.copywith(teams: updatedTeams);
    updateField(playerCricketDetails: updatedPlayerCricDetail);
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, Player>(
  (ref) => PlayerNotifier(),
);
