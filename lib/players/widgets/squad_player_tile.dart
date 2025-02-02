import 'package:flutter/material.dart';
import 'package:tracket/players/models/player_cricket_detail.dart';
import 'package:tracket/players/screens/player_profile_screen.dart';
import 'package:tracket/teams/models/team_role.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/highlighted_label.dart';

class SquadPlayerTile extends StatelessWidget {
  const SquadPlayerTile({
    super.key,
    this.isCaptain = false,
    this.isWicketKeeper = false,
    required this.cricketRole,
    required this.playerName,
    required this.profileImageUrl,
    required this.playerId,
    this.teamRole = TeamRole.none,
    this.isEdit = false,
    this.onDelete,
  });

  final String playerId;
  final String playerName;
  final CricketRole cricketRole;
  final String profileImageUrl;
  final TeamRole teamRole;
  final bool isCaptain;
  final bool isWicketKeeper;
  final bool isEdit;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          pushScreen(context, PlayerProfileScreen(playerId: playerId));
        },
        child: Expanded(
          child: Row(
            children: [
              getCircleAvatar(url: profileImageUrl, isTeam: false, radius: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      playerName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 18),
                    ),
                    Wrap(children: [
                      Text(
                        cricketRole.name,
                        style: MyTextStyle(context).bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (isCaptain)
                          HighlightedLabel(
                            text: 'Captain',
                            bgColor: Colors.blue.shade100,
                            textColor: Colors.blue.shade900,
                          ),
                        if (isCaptain && isWicketKeeper)
                          const SizedBox(width: 7),
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
              ),
              if (isEdit && teamRole != TeamRole.owner)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete),
                  iconSize: 25,
                  color: Colors.red,
                )
            ],
          ),
        ),
      ),
    );
  }
}
