import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                Text('Match 1'),
                Spacer(),
                Text('12:30 PM'),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Column(
                  children: [
                    getCircleAvatar(url: '', isTeam: true, radius: 30),
                    Text(
                      'Team A',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '121/5',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text('10'),
                  ],
                ),
                const Spacer(),
                Text(
                  'v/s',
                  style: MyTextStyle(context).boldBodyLarge,
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '50/2',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text('6.5'),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    getCircleAvatar(url: '', isTeam: true, radius: 30),
                    Text(
                      'Team B',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text('BowlerName   15/1 (1.5)'),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Text('10 (6)    Batsman1Name'),
                    Text('25 (15)   Batsman2Name'),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
