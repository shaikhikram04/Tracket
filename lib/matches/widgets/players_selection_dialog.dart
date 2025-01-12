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
  List<PlayerDetails> _sPlayers = [];

  @override
  void initState() {
    _sPlayers =
        widget.selectedPlayers.map((player) => player.copyWith()).toList();

    super.initState();
  }

  void _onSelect(PlayerDetails player, bool isAdded) {
    if (isAdded) {
      setState(() {
        _sPlayers.removeWhere((p) => p.id == player.id);
      });
    } else {
      if (_sPlayers.length >= widget.noOfPlayerCanBeSelected) {
        showSnackBar('Players has reached its max capacity', context);
        return;
      }
      setState(() {
        _sPlayers.add(player.copyWith());
      });
    }
  }

  void _onSubmit() {
    final requiredPlayerLen = widget.noOfPlayerCanBeSelected;
    final selectedPlayerLen = _sPlayers.length;
    final moreToSelect = requiredPlayerLen - selectedPlayerLen;
    //! make sure that all required players are selected
    // if (selectedPlayerLen != requiredPlayerLen) {
    //   showAlertDialog(
    //     context,
    //     'Incomplete selection',
    //     'This match need $requiredPlayerLen players but you selected $selectedPlayerLen. Please select $moreToSelect more player!',
    //   );

    //   return;
    // }
    Navigator.of(context).pop(_sPlayers);
  }

  @override
  void dispose() {
    _sPlayers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Dialog(
      child: SizedBox(
        height: height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getTitleText('Select players', context),
                  Text('${_sPlayers.length}/${widget.noOfPlayerCanBeSelected}')
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
                    final isAdded = _sPlayers
                        .any((playerData) => playerData.id == player.id);
                    return InkWell(
                      onTap: () => _onSelect(player, isAdded),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isAdded ? lightCardColor : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                    onPressed: _onSubmit,
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
