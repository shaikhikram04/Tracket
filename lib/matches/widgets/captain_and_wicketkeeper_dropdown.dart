import 'package:flutter/material.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';
import 'package:tracket/widgets/custom_widgets/my_dropdown_menu.dart';

class CaptainAndWicketkeeperDropdown extends StatelessWidget {
  const CaptainAndWicketkeeperDropdown({
    super.key,
    required this.playersName,
    required this.captainController,
    required this.captainId,
    required this.selectedPlayers,
    required this.wicketkeeperController,
    required this.wicketkeeperId,
  });

  final List<String> playersName;
  final TextEditingController captainController;
  final ValueNotifier<String> captainId;
  final ValueNotifier<List<MatchPlayerInfo>> selectedPlayers;
  final TextEditingController wicketkeeperController;
  final ValueNotifier<String> wicketkeeperId;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Column(
        children: [
          getTitleText('Roles', context),
          SizedBox(height: 10),
          MyDropdownMenu(
            options: playersName,
            label: 'Change Captaincy',
            controller: captainController,
            onSelect: (value) {
              if (value != null) {
                final index = playersName.indexOf(value);
                captainId.value = selectedPlayers.value[index].playerId;
              }
            },
          ),
          const SizedBox(height: 12),
          MyDropdownMenu(
            options: playersName,
            label: 'Change Wicketkeeper',
            controller: wicketkeeperController,
            onSelect: (value) {
              if (value != null) {
                final index = playersName.indexOf(value);
                wicketkeeperId.value = selectedPlayers.value[index].playerId;
              }
            },
          ),
        ],
      ),
    );
  }
}
