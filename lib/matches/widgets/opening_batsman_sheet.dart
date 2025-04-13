import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/widgets/base_selection_sheet.dart';
import 'package:tracket/utils/constants/colors.dart';

class OpeningBatsmenSheet extends StatefulWidget {
  final List<MatchPlayerInfo> availablePlayers;
  final Function(MatchPlayerInfo striker, MatchPlayerInfo nonStriker) onConfirm;

  const OpeningBatsmenSheet({
    Key? key,
    required this.availablePlayers,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<OpeningBatsmenSheet> createState() => _OpeningBatsmenSheetState();
}

class _OpeningBatsmenSheetState extends State<OpeningBatsmenSheet> {
  MatchPlayerInfo? striker;
  MatchPlayerInfo? nonStriker;

  @override
  Widget build(BuildContext context) {
    return BaseSelectionSheet(
      title: 'Select Striker and Non-Striker',
      instructions: 'Choose the two opening batsmen',
      confirmEnabled: striker != null && nonStriker != null,
      onCancel: () => Navigator.pop(context),
      onConfirm: () {
        if (striker != null && nonStriker != null) {
          widget.onConfirm(striker!, nonStriker!);
          Navigator.pop(context);
        }
      },
      content: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.availablePlayers.length,
        itemBuilder: (context, index) {
          final player = widget.availablePlayers[index];
          final isStriker = striker == player;
          final isNonStriker = nonStriker == player;
          final isSelected = isStriker || isNonStriker;

          return Card(
            elevation: isSelected ? 4 : 1,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: isSelected ? Colors.green[100] : Colors.white,
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isStriker) {
                    striker = null;
                  } else if (isNonStriker) {
                    nonStriker = null;
                  } else if (striker == null) {
                    striker = player;
                  } else if (nonStriker == null) {
                    nonStriker = player;
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      isStriker
                          ? Icons.looks_one
                          : isNonStriker
                              ? Icons.looks_two
                              : Icons.person_outline,
                      color: isSelected ? grassGreen : Colors.grey,
                    ),
                    const SizedBox(width: 16),
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
                            player.longCricketRole,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Text(
                        isStriker ? 'Striker' : 'Non-Striker',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
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
