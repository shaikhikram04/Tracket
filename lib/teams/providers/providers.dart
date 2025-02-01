import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/teams/providers/request_notifier.dart';
import 'package:tracket/teams/providers/request_state.dart';
import 'package:tracket/teams/providers/team_notifier.dart';
import 'package:tracket/teams/providers/team_state.dart';

final requestProvider = StateNotifierProvider<RequestNotifier, RequestState>(
  (ref) => RequestNotifier(),
);

final teamProvider = StateNotifierProvider<TeamNotifier, TeamState>(
  (ref) => TeamNotifier(),
);