import 'package:flutter/material.dart';
import 'package:tracket/widgets/highlighted_label.dart';

class PlayerTile extends StatelessWidget {
  const PlayerTile({
    super.key,
    this.isCaptain = false,
    this.isWicketKeeper = false,
    required this.playerName,
    required this.cricketRole,
    this.playerImageUrl,
  });

  final String playerName;
  final String cricketRole;
  final String? playerImageUrl;
  final bool isCaptain;
  final bool isWicketKeeper;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: playerImageUrl != null
                  ? NetworkImage(playerImageUrl!)
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
                      playerName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 18),
                    ),
                  ],
                ),
                Text(cricketRole),
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
            )
          ],
        ),
      ),
    );
  }
}
