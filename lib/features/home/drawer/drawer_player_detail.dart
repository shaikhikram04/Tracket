import 'package:flutter/material.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/utils/constants/colors.dart';

class DrawerPlayerDetail extends StatelessWidget {
  const DrawerPlayerDetail({
    super.key,
    required this.player,
  });

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              player.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: LightThemeColors.surfaceColor),
            ),
          ),
          Text(
            player.playerCricketDetails?.cricketRole.name ?? '',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: LightThemeColors.surfaceColor),
          ),
        ],
      ),
    );
  }
}
