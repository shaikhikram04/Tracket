import 'package:flutter/material.dart';
import 'package:tracket/features/matches/models/match_player_info.dart';
import 'package:tracket/features/matches/widgets/base_selection_sheet.dart';
import 'package:tracket/features/players/models/player_cricket_detail.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/formatters/formatter.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

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
    final isDark = THelperFunction.isDarkMode(context);

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

          final cardColor =
              isDark ? DarkThemeColors.cardColor : LightThemeColors.cardColor;

          return Card(
            elevation: isSelected ? 4 : 1,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: isSelected ? primaryColor.withValues(alpha: 0.3) : cardColor,
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
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 9,
                            ),
                            decoration: BoxDecoration(
                              color: grassGreen,
                              borderRadius:
                                  BorderRadius.circular(TSizes.borderRadiusLg),
                            ),
                            child: Text(
                              selectedPlayerPosition.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: onPrimary),
                            ),
                          )
                        : Icon(
                            Icons.person_outline,
                            color: isDark
                                ? DarkThemeColors.secondaryText
                                : LightThemeColors.secondaryText,
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
                              color: isDark
                                  ? DarkThemeColors.secondaryText
                                  : LightThemeColors.secondaryText,
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
