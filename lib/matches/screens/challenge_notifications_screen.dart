import 'package:flutter/material.dart';
import 'package:tracket/matches/screens/notification_list.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class ChallengeNotificationsScreen extends StatefulWidget {
  const ChallengeNotificationsScreen(
      {super.key, this.teamId, this.initialIndex = 0});

  final String? teamId;
  final int initialIndex;

  @override
  State<ChallengeNotificationsScreen> createState() =>
      _ChallengeNotificationsScreenState();
}

class _ChallengeNotificationsScreenState
    extends State<ChallengeNotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, initialIndex: widget.initialIndex, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Notification'),
      ),
      body: Column(
        children: [
          TabBar(
            dividerColor: Theme.of(context).colorScheme.secondary,
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabController,
            unselectedLabelColor: unSelectColor,
            labelColor: darkGreenColor,
            labelStyle: MyTextStyle(context).boldBodyLarge,
            unselectedLabelStyle: MyTextStyle(context).bodyLarge,
            tabs: const [
              Tab(
                text: 'Received',
                icon: Icon(Icons.arrow_downward),
              ),
              Tab(
                text: 'Sent',
                icon: Icon(Icons.arrow_upward),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const NotificationListScreen(
                  field: 'challengedTeamId',
                ),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
