import 'package:flutter/material.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/bowling_score.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class CurrentPlayersInfo extends StatelessWidget {
  CurrentPlayersInfo({
    super.key,
    required this.batsmen,
    required this.bowler,
    required this.strikerIndex,
  });

  final List<BattingScore> batsmen;
  final BowlingScore bowler;
  final int strikerIndex;

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
          batsmen[0].playerName,
          batsmen[0].runs.toString(),
          batsmen[0].ballsFaced.toString(),
        ),
        const SizedBox(height: 2),
        _buildPlayerInfo(
          context,
          batsmen[1].playerName,
          batsmen[1].runs.toString(),
          batsmen[1].ballsFaced.toString(),
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
          '${bowler.playerName}   ${bowler.runsGiven}/${bowler.wickets} (${bowler.oversDisplay})',
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
