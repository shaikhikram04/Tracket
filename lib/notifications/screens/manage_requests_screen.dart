import 'package:flutter/material.dart';
import 'package:tracket/notifications/widgets/requests_fetcher.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class ManageRequestsScreen extends StatefulWidget {
  const ManageRequestsScreen({super.key, this.teamId, this.initialIndex = 0});

  final String? teamId;
  final int initialIndex;

  @override
  State<ManageRequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<ManageRequestsScreen>
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
    return Column(
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
              RequestsFetcher(
                field: 'to',
                teamId: widget.teamId,
              ),
              RequestsFetcher(
                field: 'from',
                teamId: widget.teamId,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
