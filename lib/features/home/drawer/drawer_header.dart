import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/features/home/drawer/drawer_player_detail.dart';
import 'package:tracket/common/widgets/text/link_text.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/features/players/screens/player_profile_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class MainDrawerHeader extends StatelessWidget {
  const MainDrawerHeader({
    super.key,
    required this.player,
    required this.width,
  });

  final Player player;
  final double width;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: TPadding.lg,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [GradientColors.matchCardStart, GradientColors.matchCardEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ImageCircleAvatar(url: player.profileImageUrl, isTeam: false, radius: width * 0.085, hasBorder: false),
              const SizedBox(width: TSizes.lg),
              DrawerPlayerDetail(player: player),
            ],
          ),
          const SizedBox(height: TSizes.sm),
          LinkText(
            text: TTextStrings.viewProfileButton,
            onTap: () {
              Navigator.pop(context);
              THelperFunction.pushScreen(context, PlayerProfileScreen(playerId: player.id));
            },
          ),
        ],
      ),
    );
  }
}
