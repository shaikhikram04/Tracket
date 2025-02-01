import 'package:tracket/teams/models/team.dart';

class TeamState {
  final Team team;
  final bool isLoading;
  final String? error;

  const TeamState({
    required this.team,
    this.isLoading = false,
    this.error,
  });

  bool get hasError => error != null;
  bool get hasPlayers => team.playersList.isNotEmpty;
  bool get canAddMorePlayers => team.playersList.length < team.maxPlayersCapacity;

  TeamState copyWith({
    Team? team,
    bool? isLoading,
    String? error,
  }) {
    return TeamState(
      team: team ?? this.team,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}