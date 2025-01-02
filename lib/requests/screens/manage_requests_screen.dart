import 'package:flutter/material.dart';
import 'package:tracket/requests/screens/requests_list_screen.dart';
import 'package:tracket/utils/colors.dart';

class ManageRequestsScreen extends StatefulWidget {
  const ManageRequestsScreen({super.key, this.teamId});

  final String? teamId;

  @override
  State<ManageRequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<ManageRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Requests'),
      ),
      body: Column(
        children: [
          TabBar(
            dividerColor: Theme.of(context).colorScheme.secondary,
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabController,
            unselectedLabelColor: unSelectColor,
            labelColor: darkGreenColor,
            labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            unselectedLabelStyle: Theme.of(context).textTheme.bodyLarge,
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
              children: const [
                RequestsListScreen(
                  field: 'to',
                ),
                RequestsListScreen(
                  field: 'from',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
