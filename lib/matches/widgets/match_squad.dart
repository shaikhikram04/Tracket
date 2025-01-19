import 'package:flutter/material.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/players/widgets/player_tile.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/widgets/no_data_found.dart';

class MatchSquad extends StatelessWidget {
  const MatchSquad({
    super.key,
    required this.selectedPlayer,
    required this.captainId,
    required this.wicketkeeperId,
    this.onAdd,
    this.isPlayerCanAdd = true,
    this.title = 'Squad',
  });

  final List<PlayerDetails> selectedPlayer;
  final String captainId;
  final String wicketkeeperId;
  final void Function()? onAdd;
  final bool isPlayerCanAdd;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              title,
              style: MyTextStyle(context).titleMedium.copyWith(fontSize: 23),
            ),
            const Spacer(),
            if (isPlayerCanAdd)
              IconButton(
                onPressed: onAdd,
                iconSize: 30,
                icon: const Icon(Icons.group_add),
              )
          ],
        ),
        const SizedBox(height: 10),
        selectedPlayer.isEmpty
            ? const NoDataFound(
                title: 'No Player selected yet!',
                message: 'Tap the button above to select player.',
                isPointingButton: true,
              )
            : Column(
                children: List.generate(
                  selectedPlayer.length,
                  (index) {
                    final playerDetail = selectedPlayer[index];
                    final playerId = playerDetail.id;
                    final isCaptain = captainId == playerId;
                    final isWicketKeeper = wicketkeeperId == playerId;
                    return PlayerTile(
                      playerData: playerDetail,
                      isCaptain: isCaptain,
                      isWicketKeeper: isWicketKeeper,
                      isEdit: false,
                    );
                  },
                ),
              ),
      ],
    );
  }
}
