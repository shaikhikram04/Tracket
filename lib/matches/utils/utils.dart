import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match_player_info.dart';

List<String> getPlayerNames(
        ValueNotifier<List<MatchPlayerInfo>> selectedPlayers) =>
    selectedPlayers.value
        .map((player) => player.playerName.toUpperCase())
        .toList();
