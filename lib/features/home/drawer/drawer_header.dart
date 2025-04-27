import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/image_circle_avatar.dart';
import 'package:tracket/features/home/drawer/drawer_player_detail.dart';
import 'package:tracket/features/home/drawer/drawer_view_profile.dart';
import 'package:tracket/features/players/models/player.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/paddings.dart';
import 'package:tracket/utils/constants/sizes.dart';

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
          colors: [
            GradientColors.matchCardStart,
            GradientColors.matchCardEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ImageCircleAvatar(
                url: player.profileImageUrl,
                isTeam: false,
                radius: width * 0.085,
                hasBorder: false,
              ),
              const SizedBox(width: TSizes.lg),
              DrawerPlayerDetail(player: player),
            ],
          ),
          const SizedBox(height: TSizes.sm),
          DrawerViewProfile(player: player)
        ],
      ),
    );
  }
}
