import 'package:flutter/material.dart';
import 'package:tracket/features/matches/models/match_player_info.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';
import 'package:tracket/common/widgets/custom_widgets/my_dropdown_menu.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class CaptainAndWicketkeeperDropdown extends StatelessWidget {
  const CaptainAndWicketkeeperDropdown({
    super.key,
    required this.playersName,
    required this.captainController,
    required this.selectedPlayers,
    required this.wicketkeeperController,
    required this.onSelectCaptain,
    required this.onSelectWicketkeeper,
  });

  final List<String> playersName;
  final TextEditingController captainController;
  final ValueNotifier<List<MatchPlayerInfo>> selectedPlayers;
  final TextEditingController wicketkeeperController;
  final void Function(String? id) onSelectCaptain;
  final void Function(String? id) onSelectWicketkeeper;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Column(
        children: [
          THelperFunction.getTitleText('Roles', context),
          const SizedBox(height: 10),
          MyDropdownMenu(
            options: playersName,
            label: 'Change Captaincy',
            controller: captainController,
            onSelect:onSelectCaptain
          ),
          const SizedBox(height: 16),
          MyDropdownMenu(
            options: playersName,
            label: 'Change Wicketkeeper',
            controller: wicketkeeperController,
            onSelect: onSelectWicketkeeper,
          ),
        ],
      ),
    );
  }
}
