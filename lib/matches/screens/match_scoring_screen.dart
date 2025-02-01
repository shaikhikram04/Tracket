import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';

class MatchScoringScreen extends StatelessWidget {
  const MatchScoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Details'),
      ),
      body: ListView(
        children: [
          MyCard(
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '10 (6)     Batsman1Name',
                          style: MyTextStyle(context).bodyLarge,
                        ),
                        Text(
                          '25 (15)     Batsman2Name',
                          style: MyTextStyle(context).bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'BowlerName   15/1 (1.5)',
                      style: MyTextStyle(context).bodyLarge,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
          ),
          MyCard(
              child: Column(
            children: [
              getTitleText('Current Partnership', context),
              SizedBox(height: 15),
              Text(
                'Batsman1 & Batsman2    10(8)',
                style: MyTextStyle(context).titleMedium,
              )
            ],
          )),
        ],
      ),
    );
  }
}
