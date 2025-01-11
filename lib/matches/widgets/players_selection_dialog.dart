import 'package:flutter/material.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_text_button.dart';

class PlayersSelectionDialog extends StatefulWidget {
  const PlayersSelectionDialog({
    super.key,
    required this.playerList,
    required this.selectedPlayers,
    required this.noOfPlayerCanBeSelected,
  });

  final List<PlayerDetails> playerList;
  final List<PlayerDetails> selectedPlayers;
  final int noOfPlayerCanBeSelected;

  @override
  State<PlayersSelectionDialog> createState() => _PlayersSelectionDialogState();
}

class _PlayersSelectionDialogState extends State<PlayersSelectionDialog> {
  late List<PlayerDetails> _selectedPlayer;

  @override
  void initState() {
    _selectedPlayer = widget.selectedPlayers;
    super.initState();
  }

  void _onSelect(PlayerDetails player, bool isAdded) {
    if (isAdded) {
      setState(() {
        _selectedPlayer.remove(player);
      });
    } else {
      if (_selectedPlayer.length >= widget.noOfPlayerCanBeSelected) {
        showSnackBar('Players has reached its max capacity', context);
        return;
      }
      setState(() {
        _selectedPlayer.add(player);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Dialog(
      child: SizedBox(
        height: height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getTitleText('Select players', context),
                  Text(
                      '${_selectedPlayer.length}/${widget.noOfPlayerCanBeSelected}')
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  itemCount: widget.playerList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemBuilder: (context, index) {
                    final PlayerDetails player = widget.playerList[index];
                    final isAdded = _selectedPlayer.contains(player);
                    return InkWell(
                      onTap: () => _onSelect(player, isAdded),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        color: isAdded ? lightCardColor : null,
                        child: Column(
                          children: [
                            getCircleAvatar(
                              url: player.imageUrl,
                              isTeam: false,
                              radius: 35,
                            ),
                            const SizedBox(height: 2),
                            Text(player.name),
                            Text(player.cricketRole),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 10,
                children: [
                  MyTextButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(null),
                  ),
                  MyTextButton(
                    text: 'Submit',
                    onPressed: () => Navigator.of(context).pop(_selectedPlayer),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
