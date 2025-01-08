import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/teams/models/team.dart';

class TeamProviderNotifier extends StateNotifier<Team> {
  TeamProviderNotifier(super.state);

  void updateTeam(Team team) {
    state = team;
  }

  void updateField({
    String? name,
    String? shortName,
    String? description,
    String? logoUrl,
    List<Map<String, dynamic>>? playersList,
    int? maxPlayersCapacity,
    String? captainId,
    String? wicketkeeperId,
    bool? isTeamPrivate,
    List? playerIds,
    List? followers,
  }) {
    state = state.copyWith(
      name: name,
      shortName: shortName,
      description: description,
      logoUrl: logoUrl,
      playersList: playersList,
      maxPlayersCapacity: maxPlayersCapacity,
      captainId: captainId,
      wicketkeeperId: wicketkeeperId,
      isPrivate: isTeamPrivate,
      playerIds: playerIds,
      followers: followers,
    );
  }

  void deletePlayer(String playerId) {
    final updatedPlayersList =
        state.playersList.where((player) => player['id'] != playerId).toList();

    final updatedPlayerIds =
        state.playerIds.where((id) => id != playerId).toList();
    updateField(playersList: updatedPlayersList, playerIds: updatedPlayerIds);
  }

  void addPlayer(Map<String, dynamic> player) {
    final updatedPlayersList = [...state.playersList, player];
    final updatedPlayerIds = [...state.playerIds, player['id']];
    updateField(playersList: updatedPlayersList, playerIds: updatedPlayerIds);
  }

  void updatePlayerRole(String playerId, String role) {
    final updatedPlayersList = state.playersList.map((player) {
      if (player['id'] == playerId) {
        return {
          ...player,
          'role': role,
        };
      }
      return player;
    }).toList();
    updateField(playersList: updatedPlayersList);
  }

  void incrementCapacity() {
    updateField(maxPlayersCapacity: state.maxPlayersCapacity + 1);
  }

  void decrementCapacity() {
    updateField(maxPlayersCapacity: state.maxPlayersCapacity - 1);
  }
}

final teamProvider = StateNotifierProvider<TeamProviderNotifier, Team>((ref) {
  return TeamProviderNotifier(
    Team(
      id: '',
      name: '',
      shortName: '',
      logoUrl: '',
      playersList: [],
      achievements: [],
      followers: [],
      createdBy: '',
      playerIds: [],
      description: '',
    ),
  );
});
