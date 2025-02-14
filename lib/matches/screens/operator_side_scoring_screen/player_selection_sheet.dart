import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/widgets/base_selection_sheet.dart';
import 'package:tracket/utils/colors.dart';

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
    return BaseSelectionSheet(
      title: widget.type == SelectionType.batsman
          ? 'Select the Next Batsman'
          : 'Select the Next Bowler',
      instructions: '',
      content: Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: widget.availablePlayers.length,
          itemBuilder: (context, index) {
            final player = widget.availablePlayers[index];
            return Card(
              elevation: selectedPlayer == player ? 4 : 1,
              margin: const EdgeInsets.symmetric(vertical: 4),
              color:
                  selectedPlayer == player ? Colors.green[100] : Colors.white,
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
                        activeColor: darkGreenColor,
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
      confirmEnabled: selectedPlayer != null,
      onConfirm: () {
        widget.onPlayerSelected(selectedPlayer!);
        Navigator.pop(context);
      },
      onCancel: () => Navigator.pop(context),
    );
  }
}
