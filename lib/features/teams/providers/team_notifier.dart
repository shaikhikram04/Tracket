import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/players/models/player_details.dart';
import 'package:tracket/features/teams/models/team.dart';
import 'package:tracket/features/teams/providers/team_state.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/constants/text_strings.dart';

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
        error: '${TTextStrings.failedToUpdateTeam} ${e.toString()}',
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
        error: '${TTextStrings.failedToUpdateTeamField} ${e.toString()}',
      );
    }
  }

  Future<void> deletePlayer(String playerId) async {
    if (!state.team.playerIds.contains(playerId)) {
      state = state.copyWith(error: TTextStrings.teamPlayerNotFound);
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final updatedPlayersList = state.team.playersList.where((player) => player.id != playerId).toList();
      final updatedPlayerIds = state.team.playerIds.where((id) => id != playerId).toList();

      await updateField(
        playersList: updatedPlayersList,
        playerIds: updatedPlayerIds,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '${TTextStrings.failedToDeletePlayer} ${e.toString()}',
      );
    }
  }

  Future<void> addPlayer(PlayerDetails player) async {
    if (!state.canAddMorePlayers) {
      state = state.copyWith(error: TTextStrings.teamCapacityError);
      return;
    }

    if (state.team.playerIds.contains(player.id)) {
      state = state.copyWith(error: TTextStrings.playerAlreadyInTeam);
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
        error: '${TTextStrings.failedToAddPlayer} ${e.toString()}',
      );
    }
  }

  Future<void> updatePlayerRole(String playerId, TeamRole role) async {
    final playerIndex = state.team.playersList.indexWhere((player) => player.id == playerId);

    if (playerIndex == -1) {
      state = state.copyWith(error: TTextStrings.teamPlayerNotFound);
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
        role: role,
        longCricketRole: player.longCricketRole,
      );

      await updateField(playersList: updatedPlayersList);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '${TTextStrings.failedToUpdatePlayerRole} ${e.toString()}',
      );
    }
  }

  Future<void> updateTeamCapacity(int change) async {
    final newCapacity = state.team.maxPlayersCapacity + change;

    if (newCapacity < state.team.playersList.length) {
      state = state.copyWith(
        error: TTextStrings.capacityCannotBeReduce,
      );
      return;
    }

    if (newCapacity < 1) {
      state = state.copyWith(error: TTextStrings.capacityCannotBeLessThanOne);
      return;
    }

    try {
      await updateField(maxPlayersCapacity: newCapacity);
    } catch (e) {
      state = state.copyWith(
        error: '${TTextStrings.failedToUpdateTeamCapacity} ${e.toString()}',
      );
    }
  }
}
