import 'package:flutter/material.dart';
import 'package:tracket/notifications/screens/manage_requests_screen.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
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
              Tab(text: 'All'),
              Tab(text: 'requests'),
              Tab(text: 'challenge'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(),
                const ManageRequestsScreen(),
                Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
