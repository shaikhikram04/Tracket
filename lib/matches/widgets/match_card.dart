import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
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
            const Row(
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
                    getCircleAvatar(url: '', isTeam: true, radius: 30),
                    const Text('Team A'),
                  ],
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('121/5'),
                    Text('10'),
                  ],
                ),
                const Spacer(),
                const Text('v/s'),
                const Spacer(),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('50/2'),
                    Text('6.5'),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    getCircleAvatar(url: '', isTeam: true, radius: 30),
                    const Text('Team B'),
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
            const SizedBox(height: 8),
            const Row(
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
