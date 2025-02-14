import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match_player_info.dart';

// Selection type enum
enum SelectionType { batsman, bowler }

class PlayerSelectionSheet extends StatefulWidget {
  final SelectionType type;
  final List<MatchPlayerInfo> availablePlayers;
  final Function(MatchPlayerInfo) onPlayerSelected;

  const PlayerSelectionSheet({
    Key? key,
    required this.type,
    required this.availablePlayers,
    required this.onPlayerSelected,
  }) : super(key: key);

  static Future<void> show({
    required BuildContext context,
    required SelectionType type,
    required List<MatchPlayerInfo> availablePlayers,
    required Function(MatchPlayerInfo) onPlayerSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PlayerSelectionSheet(
        type: type,
        availablePlayers: availablePlayers,
        onPlayerSelected: onPlayerSelected,
      ),
    );
  }

  @override
  State<PlayerSelectionSheet> createState() => _PlayerSelectionSheetState();
}

class _PlayerSelectionSheetState extends State<PlayerSelectionSheet> {
  MatchPlayerInfo? selectedPlayer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.type == SelectionType.batsman
                  ? 'Select the Next Batsman'
                  : 'Select the Next Bowler',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Player list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.availablePlayers.length,
              itemBuilder: (context, index) {
                final player = widget.availablePlayers[index];
                return Card(
                  elevation: selectedPlayer == player ? 4 : 1,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: selectedPlayer == player
                      ? Colors.green[50]
                      : Colors.white,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedPlayer = player;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Radio<MatchPlayerInfo>(
                            value: player,
                            groupValue: selectedPlayer,
                            onChanged: (MatchPlayerInfo? value) {
                              setState(() {
                                selectedPlayer = value;
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player.playerName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  player.cricketRole.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Action buttons
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              8 + MediaQuery.of(context).viewPadding.bottom,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedPlayer == null
                        ? null
                        : () {
                            widget.onPlayerSelected(selectedPlayer!);
                            Navigator.pop(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
