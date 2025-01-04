import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 2,
      color: whiteColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                Text('Match 1'),
                Spacer(),
                Text('12:30 PM'),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/team_logo.png'),
                      radius: 30,
                    ),
                    Text('Team A'),
                  ],
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('121/5'),
                    Text('10'),
                  ],
                ),
                Spacer(),
                Text('v/s'),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('50/2'),
                    Text('6.5'),
                  ],
                ),
                SizedBox(width: 8),
                Column(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/team_logo.png'),
                      radius: 30,
                    ),
                    Text('Team B'),
                  ],
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     CircleAvatar(
            //       radius: 14,
            //       child: Text('3'),
            //     ),
            //     SizedBox(width: 6),
            //     CircleAvatar(
            //       radius: 14,
            //       child: Text('4'),
            //     ),
            //     SizedBox(width: 6),
            //     CircleAvatar(
            //       radius: 14,
            //       child: Text('1'),
            //     ),
            //     SizedBox(width: 6),
            //     CircleAvatar(
            //       radius: 14,
            //       child: Text('2'),
            //     ),
            //     SizedBox(width: 6),
            //     CircleAvatar(
            //       radius: 14,
            //       child: Text('0'),
            //     ),
            //     SizedBox(width: 6),
            //     CircleAvatar(
            //       radius: 14,
            //       child: Text(''),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                Column(
                  children: [
                    Text('BowlerName   15/1 (1.5)'),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Text('10 (6)      Batsman1Name'),
                    Text('25 (15)     Batsman2Name'),
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
