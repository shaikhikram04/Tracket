import 'package:flutter/material.dart';
import 'package:tracket/matches/models/current_player.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class CurrentPlayersInfo extends StatelessWidget {
  const CurrentPlayersInfo({
    super.key,
    required this.striker,
    required this.nonStriker,
    required this.bowlers,
  });

  final StrikerData striker;
  final StrikerData nonStriker;
  final CurrentBowlerData bowlers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBattingInfo(context),
        const SizedBox(height: 12),
        _buildBowlingInfo(context),
      ],
    );
  }

  Widget _buildBattingInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Batting',
          style: MyTextStyle(context).bodyMedium.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 4),
        _buildPlayerInfo(
          context,
          striker.playerName,
          striker.runs.toString(),
          striker.balls.toString(),
        ),
        const SizedBox(height: 2),
        _buildPlayerInfo(
          context,
          nonStriker.playerName,
          nonStriker.runs.toString(),
          nonStriker.balls.toString(),
        ),
      ],
    );
  }

  Widget _buildBowlingInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bowling',
          style: MyTextStyle(context).bodyMedium.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '${bowlers.playerName}   ${bowlers.runsGiven}/${bowlers.wickets} (${bowlers.oversDisplay})',
          style: MyTextStyle(context).bodyLarge,
        ),
      ],
    );
  }

  Widget _buildPlayerInfo(
      BuildContext context, String name, String runs, String balls) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            name,
            style: MyTextStyle(context).bodyLarge,
          ),
        ),
        Expanded(
          child: Text(
            '$runs ($balls)',
            style: MyTextStyle(context).bodyLarge,
          ),
        ),
      ],
    );
  }
}
