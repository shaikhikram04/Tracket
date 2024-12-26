import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/models/team.dart';

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
