import 'package:flutter/material.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/highlighted_label.dart';

class PlayerTile extends StatelessWidget {
  const PlayerTile({
    super.key,
    this.isCaptain = false,
    this.isWicketKeeper = false,
    required this.playerData,
    this.isEdit = false,
    this.teamId,
    this.onDelete,
  });

  final Map<String, dynamic> playerData;
  final String? teamId;
  final bool isCaptain;
  final bool isWicketKeeper;
  final bool isEdit;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushScreen(context, PlayerProfileScreen(playerId: playerData['id']));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: playerData['imageUrl'] != null
                  ? NetworkImage(playerData['imageUrl']!)
                  : const AssetImage('assets/images/Default_user_pfp.jpg')
                      as ImageProvider,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      playerData['name'],
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 18),
                    ),
                  ],
                ),
                Text(playerData['cricketRole']),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (isCaptain)
                      HighlightedLabel(
                        text: 'Captain',
                        bgColor: Colors.blue.shade100,
                        textColor: Colors.blue.shade900,
                      ),
                    if (isWicketKeeper) const SizedBox(width: 7),
                    if (isWicketKeeper)
                      HighlightedLabel(
                        text: 'Wicketkeeper',
                        bgColor: Colors.orange.shade100,
                        textColor: Colors.orange.shade900,
                      ),
                  ],
                )
              ],
            ),
            const Spacer(),
            if (isEdit)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete),
                iconSize: 25,
                color: Colors.red,
              )
          ],
        ),
      ),
    );
  }
}
