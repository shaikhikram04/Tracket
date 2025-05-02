import 'package:flutter/material.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/features/players/screens/player_profile_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class DrawerViewProfile extends StatelessWidget {
  const DrawerViewProfile({
    super.key,
    required this.player,
  });

  final Player player;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        THelperFunction.pushScreen(
            context,
            PlayerProfileScreen(
              playerId: player.id,
            ));
      },
      child: Text(
        TTextStrings.viewProfileButton,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: onPrimary,
              fontStyle: FontStyle.italic,
              letterSpacing: 1,
              decoration: TextDecoration.underline,
              decorationColor: onPrimary,
            ),
      ),
    );
  }
}
