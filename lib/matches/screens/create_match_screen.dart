import 'package:flutter/material.dart';

class CreateMatchScreen extends StatelessWidget {
  const CreateMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Match'),
      ),
      body: const Center(
        child: Text('Create Match Screen'),
      ),
    );
  }
}
