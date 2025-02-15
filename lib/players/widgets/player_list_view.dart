import 'package:flutter/material.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/players/widgets/player_list_tile.dart';
import 'package:tracket/teams/models/team.dart';

class PlayerListView extends StatelessWidget {
  const PlayerListView({
    super.key,
    required this.players,
    required this.team,
    required this.emptyStateWidget,
    this.isPlayerPrivate = false,
  });

  final List<PlayerDetails> players;
  final Team team;
  final Widget emptyStateWidget;
  final bool isPlayerPrivate;

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) return emptyStateWidget;

    return ListView.builder(
      itemCount: players.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final player = players[index];
        return PlayerListTile(
          player: player,
          team: team,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlayerProfileScreen(playerId: player.id),
            ),
          ),
          isPrivate: isPlayerPrivate,
        );
      },
    );
  }
}
