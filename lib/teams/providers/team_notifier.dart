import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/models/team_role.dart';
import 'package:tracket/teams/providers/team_state.dart';

class TeamNotifier extends StateNotifier<TeamState> {
  TeamNotifier()
      : super(const TeamState(
          team: Team(
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
        ));

  Future<void> updateTeam(Team team) async {
    try {
      // state = state.copyWith(isLoading: true, error: null);
      // Here you could add validation logic if needed
      state = state.copyWith(team: team, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update team: ${e.toString()}',
      );
    }
  }

  Future<void> updateField({
    String? name,
    String? shortName,
    String? description,
    String? logoUrl,
    List<PlayerDetails>? playersList,
    int? maxPlayersCapacity,
    String? captainId,
    String? wicketkeeperId,
    bool? isTeamPrivate,
    List<String>? playerIds,
    List<String>? followers,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final updatedTeam = state.team.copyWith(
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

      state = state.copyWith(team: updatedTeam, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update team field: ${e.toString()}',
      );
    }
  }

  Future<void> deletePlayer(String playerId) async {
    if (!state.team.playerIds.contains(playerId)) {
      state = state.copyWith(error: 'Player not found in team');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final updatedPlayersList = state.team.playersList
          .where((player) => player.id != playerId)
          .toList();
      final updatedPlayerIds =
          state.team.playerIds.where((id) => id != playerId).toList();

      await updateField(
        playersList: updatedPlayersList,
        playerIds: updatedPlayerIds,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete player: ${e.toString()}',
      );
    }
  }

  Future<void> addPlayer(PlayerDetails player) async {
    if (!state.canAddMorePlayers) {
      state = state.copyWith(error: 'Team has reached maximum capacity');
      return;
    }

    if (state.team.playerIds.contains(player.id)) {
      state = state.copyWith(error: 'Player already exists in team');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      await updateField(
        playersList: [...state.team.playersList, player],
        playerIds: [...state.team.playerIds, player.id],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to add player: ${e.toString()}',
      );
    }
  }

  Future<void> updatePlayerRole(String playerId, TeamRole role) async {
    final playerIndex =
        state.team.playersList.indexWhere((player) => player.id == playerId);

    if (playerIndex == -1) {
      state = state.copyWith(error: 'Player not found in team');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final updatedPlayersList = [...state.team.playersList];
      final player = updatedPlayersList[playerIndex];

      updatedPlayersList[playerIndex] = PlayerDetails(
        cricketRole: player.cricketRole,
        id: player.id,
        imageUrl: player.imageUrl,
        name: player.name,
        role: role, longCricketRole: player.longCricketRole,
      );

      await updateField(playersList: updatedPlayersList);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update player role: ${e.toString()}',
      );
    }
  }

  Future<void> updateTeamCapacity(int change) async {
    final newCapacity = state.team.maxPlayersCapacity + change;

    if (newCapacity < state.team.playersList.length) {
      state = state.copyWith(
        error: 'Cannot reduce capacity below current team size',
      );
      return;
    }

    if (newCapacity < 1) {
      state = state.copyWith(error: 'Team capacity cannot be less than 1');
      return;
    }

    try {
      await updateField(maxPlayersCapacity: newCapacity);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update team capacity: ${e.toString()}',
      );
    }
  }
}
