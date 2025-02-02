import 'package:flutter/material.dart';
import 'package:tracket/matches/widgets/scoreboard.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';

class MatchScoringScreen extends StatelessWidget {
  const MatchScoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Details'),
        backgroundColor: whiteColor,
        shape: Border.all(color: Colors.black45, width: 0.3),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.black45, width: 0.5)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1st Feb 2025'),
                    Text(
                      'Live',
                      style: MyTextStyle(context)
                          .coloredBodyLarge(greenColor)
                          .copyWith(
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
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
                  spacing: 15,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: greenColor,
                      child: Text('4'),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 237, 103, 94),
                      child: Text('W'),
                    ),
                    CircleAvatar(
                      backgroundColor: greenColor,
                      child: Text('6'),
                    ),
                    CircleAvatar(
                      child: Text('2'),
                    ),
                    CircleAvatar(
                      child: Text('0'),
                    ),
                    CircleAvatar(
                      child: Text('-'),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BattingTeam Batting'),
                        Text(
                          'Batsman1Name     10 (6)',
                          style: MyTextStyle(context).bodyLarge,
                        ),
                        Text(
                          'Batsman2Name     25 (15)',
                          style: MyTextStyle(context).bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BowlingTeam Bowling'),
                        Text(
                          'BowlerName   15/1 (1.5)',
                          style: MyTextStyle(context).bodyLarge,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 250, 255, 250),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                getTitleText('Scoreboard', context),
                Scoreboard(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
