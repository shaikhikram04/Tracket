import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_team_info.dart';

class MatchStateNotifier extends StateNotifier<Match> {
  MatchStateNotifier(super.state);
}

final matchStateProvider = StateNotifierProvider<MatchStateNotifier, Match>(
  (ref) {
    final state = Match(
      team1: MatchTeamInfo(
          teamId: '1',
          captainId: '',
          logoUrl: '',
          shortName: '',
          teamName: '',
          wicketkeeperId: ''),
      team2: MatchTeamInfo(
          teamId: '',
          captainId: '',
          logoUrl: '',
          shortName: '',
          teamName: '',
          wicketkeeperId: ''),
      team1Players: [],
      team2Players: [],
      noOfPlayer: 0,
      matchFormat: MatchFormat.over10,
      matchType: MatchType.challenged,
      venue: '',
      schedule: DateTime.now(),
      striker: null,
      nonStriker: null,
      currentBowlers: null,
    );
    return MatchStateNotifier(state);
  },
);
