import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/widgets/base_selection_sheet.dart';
import 'package:tracket/players/models/player_cricket_detail.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/formatters/formatter.dart';

class OpeningBowlerSheet extends StatefulWidget {
  final List<MatchPlayerInfo> availablePlayers;
  final Function(MatchPlayerInfo bowler) onConfirm;

  const OpeningBowlerSheet({
    Key? key,
    required this.availablePlayers,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<OpeningBowlerSheet> createState() => _OpeningBowlerSheetState();
}

class _OpeningBowlerSheetState extends State<OpeningBowlerSheet> {
  MatchPlayerInfo? selectedBowler;

  @override
  Widget build(BuildContext context) {
    return BaseSelectionSheet(
      title: 'Select the Opening Bowler',
      instructions: 'Choose the first bowler for the match',
      confirmEnabled: selectedBowler != null,
      onCancel: () => Navigator.pop(context),
      onConfirm: () {
        if (selectedBowler != null) {
          widget.onConfirm(selectedBowler!);
          Navigator.pop(context);
        }
      },
      content: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.availablePlayers.length,
        itemBuilder: (context, index) {
          final player = widget.availablePlayers[index];
          final isSelected = selectedBowler == player;
          final canBowl = player.cricketRole == CricketRole.bowler ||
              player.cricketRole == CricketRole.allRounder;

          if (!canBowl) return const SizedBox.shrink();

          return Card(
            elevation: isSelected ? 4 : 1,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: isSelected ? Colors.green[100] : Colors.white,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedBowler = player;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Radio<MatchPlayerInfo>(
                      value: player,
                      groupValue: selectedBowler,
                      onChanged: (MatchPlayerInfo? value) {
                        setState(() {
                          selectedBowler = value;
                        });
                      },
                      activeColor: grassGreen,
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
                            AppFormatter.formatBowlerSubTitle(
                                player.longCricketRole),
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
    );
  }
}
