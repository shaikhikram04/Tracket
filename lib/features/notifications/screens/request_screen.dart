import 'package:flutter/material.dart';
import 'package:tracket/features/notifications/widgets/manage_requests_screen.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key, this.teamId});

  final String? teamId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests'),
      ),
      body: ManageRequestsScreen(
        teamId: teamId,
      ),
    );
  }
}
