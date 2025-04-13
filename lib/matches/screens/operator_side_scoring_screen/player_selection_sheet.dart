import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/widgets/base_selection_sheet.dart';
import 'package:tracket/players/models/player_cricket_detail.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/formatters/formatter.dart';

enum SelectionType { batsman, bowler }

class PlayerSelectionSheet extends StatefulWidget {
  final SelectionType type;
  final List<MatchPlayerInfo> allPlayers;
  final List<String> nonAvailablePlayers;
  final String? playingPlayer;
  final Function(MatchPlayerInfo player) onPlayerSelected;

  const PlayerSelectionSheet({
    Key? key,
    required this.type,
    required this.allPlayers,
    required this.onPlayerSelected,
    required this.nonAvailablePlayers,
    this.playingPlayer,
  }) : super(key: key);

  static Future<void> show({
    required BuildContext context,
    required SelectionType type,
    required List<MatchPlayerInfo> allPlayers,
    required List<String> nonAvailablePlayers,
    required Function(MatchPlayerInfo player) onPlayerSelected,
    String? playingPlayerId,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      barrierColor: Colors.black54,
      builder: (context) => PopScope(
        canPop: false,
        child: PlayerSelectionSheet(
          type: type,
          allPlayers: allPlayers,
          onPlayerSelected: onPlayerSelected,
          nonAvailablePlayers: nonAvailablePlayers,
          playingPlayer: playingPlayerId,
        ),
      ),
    );
  }

  @override
  State<PlayerSelectionSheet> createState() => _PlayerSelectionSheetState();
}

class _PlayerSelectionSheetState extends State<PlayerSelectionSheet> {
  MatchPlayerInfo? _selectedPlayer;

  bool isPlayerDisabled(MatchPlayerInfo player) {
    return widget.nonAvailablePlayers.contains(player.playerId) ||
        widget.playingPlayer == player.playerId;
  }

  Color getCardBackgroundColor(MatchPlayerInfo player) {
    if (widget.nonAvailablePlayers.contains(player.playerId)) {
      if (widget.type == SelectionType.batsman)
        return const Color(0xFFFFF1F0); // Light red background for out players

      return const Color.fromARGB(
          255, 230, 255, 255); // Light orange background for previous bowler
    } else if (widget.playingPlayer == player.playerId) {
      if (widget.type == SelectionType.batsman)
        return const Color(0xFFF0F5FF); // Light blue background for playing players

      return const Color(0xFFFFF7E6); // Light orange background for previous bowler
    } else if (_selectedPlayer == player) {
      return const Color(0xFFF6FFED); // Light green background for selected player
    }
    return Colors.white;
  }

  Color getIconColor(MatchPlayerInfo player) {
    if (widget.nonAvailablePlayers.contains(player.playerId)) {
      if (widget.type == SelectionType.batsman)
        return const Color(0xFFCF1322); // Dark red for out icon
      return const Color.fromARGB(
          255, 231, 22, 250); // Orange for previous bowler icon
    } else if (widget.playingPlayer == player.playerId) {
      if (widget.type == SelectionType.batsman)
        return const Color(0xFF1890FF); // Blue for playing icon

      return const Color(0xFFFA8C16); // Orange for previous bowler icon
    }
    return Colors.black;
  }

  Widget? getStatusIcon(MatchPlayerInfo player) {
    if (widget.nonAvailablePlayers.contains(player.playerId)) {
      return Icon(Icons.close, color: getIconColor(player), size: 20);
    } else if (widget.playingPlayer == player.playerId) {
      if (widget.type == SelectionType.batsman)
        return Icon(
          Icons.sports_cricket,
          color: getIconColor(player),
          size: 20,
        );

      return Icon(Icons.history, color: getIconColor(player), size: 20);
    }
    return null;
  }

  String getPlayerStatus(MatchPlayerInfo player, int? playerIndex) {
    if (widget.nonAvailablePlayers.contains(player.playerId)) {
      if (widget.type == SelectionType.batsman) return "Out";
      return 'Overs Completed';
    } else if (widget.playingPlayer == player.playerId) {
      if (widget.type == SelectionType.batsman) return "Currently Playing";
      return "Previous Bowler";
    }

    return "Available";
  }

  @override
  Widget build(BuildContext context) {
    return BaseSelectionSheet(
      showCancelButton: false,
      title: widget.type == SelectionType.batsman
          ? 'Select the Next Batsman'
          : 'Select the Next Bowler',
      instructions: widget.type == SelectionType.batsman
          ? 'Choose the next batsman to play'
          : 'Select the bowler for the next over',
      content: Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: widget.allPlayers.length,
          itemBuilder: (context, index) {
            final player = widget.allPlayers[index];
            if (widget.type == SelectionType.bowler &&
                (player.cricketRole != CricketRole.allRounder &&
                    player.cricketRole != CricketRole.bowler)) {
              return Container();
            }

            final isDisabled = isPlayerDisabled(player);

            return Card(
              elevation: _selectedPlayer == player ? 4 : 1,
              margin: const EdgeInsets.symmetric(vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: _selectedPlayer == player
                      ? StatusColors.success
                      : Colors.grey.withValues(alpha: 0.2),
                  width: _selectedPlayer == player ? 2 : 1,
                ),
              ),
              color: getCardBackgroundColor(player),
              child: InkWell(
                onTap: isDisabled
                    ? null
                    : () {
                        setState(() {
                          _selectedPlayer = player;
                        });
                      },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDisabled
                              ? Colors.grey.withValues(alpha: 0.1)
                              : Colors.white,
                          border: Border.all(
                            color: isDisabled
                                ? Colors.grey.withValues(alpha: 0.2)
                                : Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                        child: getStatusIcon(player) ??
                            Icon(
                              Icons.person,
                              color: isDisabled
                                  ? Colors.grey.withValues(alpha: 0.5)
                                  : Colors.grey,
                              size: 20,
                            ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  player.playerName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isDisabled
                                        ? Colors.grey[600]
                                        : Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDisabled
                                        ? Colors.grey.withValues(alpha: 0.1)
                                        : Colors.white.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDisabled
                                          ? Colors.grey.withValues(alpha: 0.2)
                                          : Colors.grey.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Text(
                                    getPlayerStatus(player, index),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDisabled
                                          ? Colors.grey[600]
                                          : Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.type == SelectionType.bowler
                                  ? AppFormatter.formatBowlerSubTitle(
                                      player.longCricketRole)
                                  : player.longCricketRole,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDisabled
                                    ? Colors.grey[500]
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isDisabled)
                        Radio<MatchPlayerInfo>(
                          value: player,
                          groupValue: _selectedPlayer,
                          onChanged: isDisabled
                              ? null
                              : (MatchPlayerInfo? value) {
                                  setState(() {
                                    _selectedPlayer = value;
                                  });
                                },
                          activeColor: grassGreen,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      confirmEnabled: _selectedPlayer != null,
      onConfirm: () {
        widget.onPlayerSelected(_selectedPlayer!);
        Navigator.pop(context);
      },
      onCancel: () => Navigator.pop(context),
    );
  }
}
