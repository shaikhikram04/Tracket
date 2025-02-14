import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/widgets/base_selection_sheet.dart';
import 'package:tracket/utils/colors.dart';

enum SelectionType { batsman, bowler }

class PlayerSelectionSheet extends StatefulWidget {
  final SelectionType type;
  final List<MatchPlayerInfo> availablePlayers;
  final Function(MatchPlayerInfo) onPlayerSelected;
  final MatchPlayerInfo? previousBowler;

  const PlayerSelectionSheet({
    Key? key,
    required this.type,
    required this.availablePlayers,
    required this.onPlayerSelected,
    this.previousBowler,
  }) : super(key: key);

  static Future<void> show({
    required BuildContext context,
    required SelectionType type,
    required List<MatchPlayerInfo> availablePlayers,
    required Function(MatchPlayerInfo) onPlayerSelected,
    MatchPlayerInfo? previousBowler,
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
          availablePlayers: availablePlayers,
          onPlayerSelected: onPlayerSelected,
          previousBowler: previousBowler,
        ),
      ),
    );
  }

  @override
  State<PlayerSelectionSheet> createState() => _PlayerSelectionSheetState();
}

class _PlayerSelectionSheetState extends State<PlayerSelectionSheet> {
  MatchPlayerInfo? selectedPlayer;

  bool isPlayerDisabled(MatchPlayerInfo player) {
    if (widget.type == SelectionType.batsman) {
      return player.battingStatus == BattingStatus.out ||
          player.battingStatus == BattingStatus.playing;
    } else {
      return player.battingStatus == BattingStatus.playing ||
          player == widget.previousBowler;
    }
  }

  Color getCardBackgroundColor(MatchPlayerInfo player) {
    if (player.battingStatus == BattingStatus.out) {
      return Color(0xFFFFF1F0); // Light red background for out players
    } else if (player.battingStatus == BattingStatus.playing) {
      return Color(0xFFF0F5FF); // Light blue background for playing players
    } else if (widget.type == SelectionType.bowler &&
        player == widget.previousBowler) {
      return Color(0xFFFFF7E6); // Light orange background for previous bowler
    } else if (selectedPlayer == player) {
      return Color(0xFFF6FFED); // Light green background for selected player
    }
    return Colors.white;
  }

  Color getIconColor(MatchPlayerInfo player) {
    if (player.battingStatus == BattingStatus.out) {
      return Color(0xFFCF1322); // Dark red for out icon
    } else if (player.battingStatus == BattingStatus.playing) {
      return Color(0xFF1890FF); // Blue for playing icon
    } else if (widget.type == SelectionType.bowler &&
        player == widget.previousBowler) {
      return Color(0xFFFA8C16); // Orange for previous bowler icon
    }
    return Colors.black;
  }

  Widget? getStatusIcon(MatchPlayerInfo player) {
    if (player.battingStatus == BattingStatus.out) {
      return Icon(Icons.close, color: getIconColor(player), size: 20);
    } else if (player.battingStatus == BattingStatus.playing) {
      return Icon(Icons.sports_cricket, color: getIconColor(player), size: 20);
    } else if (widget.type == SelectionType.bowler &&
        player == widget.previousBowler) {
      return Icon(Icons.history, color: getIconColor(player), size: 20);
    }
    return null;
  }

  String getPlayerStatus(MatchPlayerInfo player) {
    if (player.battingStatus == BattingStatus.out) {
      return "Out";
    } else if (player.battingStatus == BattingStatus.playing) {
      return "Currently Playing";
    } else if (widget.type == SelectionType.bowler &&
        player == widget.previousBowler) {
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
          itemCount: widget.availablePlayers.length,
          itemBuilder: (context, index) {
            final player = widget.availablePlayers[index];
            final isDisabled = isPlayerDisabled(player);

            return Card(
              elevation: selectedPlayer == player ? 4 : 1,
              margin: const EdgeInsets.symmetric(vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: selectedPlayer == player
                      ? successColor
                      : Colors.grey.withValues(alpha: 0.2),
                  width: selectedPlayer == player ? 2 : 1,
                ),
              ),
              color: getCardBackgroundColor(player),
              child: InkWell(
                onTap: isDisabled
                    ? null
                    : () {
                        setState(() {
                          selectedPlayer = player;
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
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  player.cricketRole.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDisabled
                                        ? Colors.grey[500]
                                        : Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
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
                                    getPlayerStatus(player),
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
                          ],
                        ),
                      ),
                      Radio<MatchPlayerInfo>(
                        value: player,
                        groupValue: selectedPlayer,
                        onChanged: isDisabled
                            ? null
                            : (MatchPlayerInfo? value) {
                                setState(() {
                                  selectedPlayer = value;
                                });
                              },
                        activeColor: darkGreenColor,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      confirmEnabled: selectedPlayer != null,
      onConfirm: () {
        widget.onPlayerSelected(selectedPlayer!);
        Navigator.pop(context);
      },
      onCancel: () => Navigator.pop(context),
    );
  }
}
