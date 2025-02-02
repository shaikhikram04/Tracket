import 'package:flutter/material.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class CurrentPlayersInfo extends StatelessWidget {
  const CurrentPlayersInfo({super.key});

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
        _buildPlayerInfo(context, 'Batsman1Name', '10', '6'),
        const SizedBox(height: 2),
        _buildPlayerInfo(context, 'Batsman2Name', '25', '15'),
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
          'BowlerName   15/1 (1.5)',
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
