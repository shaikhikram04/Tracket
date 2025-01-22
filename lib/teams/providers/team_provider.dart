import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/models/team_details.dart';

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
    List<PlayerDetails>? playersList,
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
        state.playersList.where((player) => player.id != playerId).toList();

    final updatedPlayerIds =
        state.playerIds.where((id) => id != playerId).toList();
    updateField(playersList: updatedPlayersList, playerIds: updatedPlayerIds);
  }

  void addPlayer(PlayerDetails player) {
    final updatedPlayersList = [...state.playersList, player];
    final updatedPlayerIds = [...state.playerIds, player.id];
    updateField(playersList: updatedPlayersList, playerIds: updatedPlayerIds);
  }

  void updatePlayerRole(String playerId, TeamRole role) {
    final updatedPlayersList = state.playersList.map((player) {
      if (player.id == playerId) {
        return PlayerDetails(
          cricketRole: player.cricketRole,
          id: player.id,
          imageUrl: player.imageUrl,
          name: player.name,
          role: role,
        );
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
      requestedPlayers: [],
      challengedTeams: [],
    ),
  );
});
