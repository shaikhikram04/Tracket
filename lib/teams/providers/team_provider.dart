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
    List? playersList,
    int? maxPlayersCapacity,
  }) {
    state = state.copyWith(
      name: name,
      shortName: shortName,
      description: description,
      logoUrl: logoUrl,
      playersList: playersList,
      maxPlayersCapacity: maxPlayersCapacity,
    );
  }

  void deletePlayer(String playerId) {
    final updatedPlayersList = state.playersList
        .where((player) => player['id'] != playerId)
        .toList();
    updateField(playersList: updatedPlayersList);
  }

  void addPlayer(Map<String, dynamic> player) {
    final updatedPlayersList = [...state.playersList, player];
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
      following: [],
      followers: [],
      createdBy: '',
    ),
  );
});
