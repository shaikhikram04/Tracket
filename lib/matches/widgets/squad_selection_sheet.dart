import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/widgets/base_selection_sheet.dart';
import 'package:tracket/players/models/player_cricket_detail.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/formatters/formatter.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class SquadSelectionSheet extends StatefulWidget {
  final List<MatchPlayerInfo> playerList;
  final int noOfPlayerCanBeSelected;
  final void Function(List<MatchPlayerInfo> selectedPlayers) onSubmit;

  const SquadSelectionSheet({
    super.key,
    required this.playerList,
    required this.noOfPlayerCanBeSelected,
    required this.onSubmit,
  });

  @override
  State<SquadSelectionSheet> createState() => _SquadSelectionSheetState();

  static Future<void> show(
    BuildContext context, {
    required List<MatchPlayerInfo> playersList,
    required int noOfPlayersCanBeSelected,
    required void Function(List<MatchPlayerInfo> selectedPlayers) onSubmit,
  }) async {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      enableDrag: false,
      isScrollControlled: true,
      builder: (context) => SquadSelectionSheet(
        playerList: playersList,
        noOfPlayerCanBeSelected: noOfPlayersCanBeSelected,
        onSubmit: onSubmit,
      ),
    );
  }
}

class _SquadSelectionSheetState extends State<SquadSelectionSheet> {
  List<MatchPlayerInfo> _selectedPlayers = [];

  @override
  Widget build(BuildContext context) {
    return BaseSelectionSheet(
      title: 'Select Match Squad',
      instructions:
          'Choose the ${widget.noOfPlayerCanBeSelected} players for a match',
      content: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.playerList.length,
        itemBuilder: (context, index) {
          final player = widget.playerList[index];
          final isSelected = _selectedPlayers.contains(player);
          final selectedPlayerPosition = _selectedPlayers.indexOf(player) + 1;

          return Card(
            elevation: isSelected ? 4 : 1,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: isSelected ? Colors.green[100] : Colors.white,
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedPlayers.remove(player);
                  } else {
                    if (_selectedPlayers.length >=
                        widget.noOfPlayerCanBeSelected) return;
                    _selectedPlayers.add(player);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    selectedPlayerPosition > 0
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 9,
                            ),
                            decoration: BoxDecoration(
                              color: grassGreen,
                              borderRadius:
                                  BorderRadius.circular(AppSize.radiusSm),
                            ),
                            child: Text(
                              selectedPlayerPosition.toString(),
                              style: MyTextStyle(context)
                                  .titleSmall
                                  .copyWith(color: onPrimary),
                            ),
                          )
                        : Icon(
                            Icons.person_outline,
                            color: Colors.grey,
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
                            player.cricketRole == CricketRole.bowler
                                ? AppFormatter.formatBowlerSubTitle(
                                    player.longCricketRole)
                                : player.longCricketRole,
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
      onCancel: () => Navigator.of(context).pop(),
      confirmEnabled: _selectedPlayers.length == widget.noOfPlayerCanBeSelected,
      onConfirm: () => widget.onSubmit(_selectedPlayers),
    );
  }
}
