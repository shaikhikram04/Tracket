import 'package:flutter/material.dart';
import 'package:tracket/notifications/tab_components/base_tab_screen.dart';
import 'package:tracket/notifications/tab_components/notification_tab_config.dart';
import 'package:tracket/notifications/tab_components/tab_controller_mixin.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class Scoreboard extends BaseTabScreen {
  const Scoreboard({super.key});

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard>
    with SingleTickerProviderStateMixin, TabControllerMixin {
  static const _tabs = [
    NotificationTabConfig(text: 'Team1 Inning'),
    NotificationTabConfig(text: 'Team2 Inning'),
  ];

  @override
  void initState() {
    super.initState();
    initTabController(_tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTabBar(tabs: _tabs),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              SizedBox(
                width: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Batting'),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      'Batsman1 name',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      'c fielder1   b fielder2',
                      style: MyTextStyle(context)
                          .bodyMedium
                          .copyWith(color: Colors.grey.shade600),
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      'Batsman2 name',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      'Not out',
                      style: MyTextStyle(context)
                          .bodyMedium
                          .copyWith(color: Colors.grey.shade600),
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      'Batsman2 name',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      'Not out',
                      style: MyTextStyle(context)
                          .bodyMedium
                          .copyWith(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
                child: Column(
                  children: [
                    Text('R'),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '7',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      ' ',
                      style: MyTextStyle(context)
                          .bodyMedium
                          .copyWith(color: Colors.grey.shade600),
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '20',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      '',
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '20',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      '',
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
                child: Column(
                  children: [
                    Text('B'),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '9',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      '',
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '14',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      '',
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '14',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      '',
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
                child: Column(
                  children: [
                    Text("4's"),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '1',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      '',
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '2',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      '',
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '2',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      '',
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
                child: Column(
                  children: [
                    Text("6's"),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '0',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      '',
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '0',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      '',
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '0',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      '',
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 60,
                child: Column(
                  children: [
                    Text('S/R'),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '80.64',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      '',
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '117.54',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      '',
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      color: Colors.black38,
                    ),
                    Text(
                      '117.54',
                      style: MyTextStyle(context).bodyLarge,
                    ),
                    Text(
                      '',
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}
