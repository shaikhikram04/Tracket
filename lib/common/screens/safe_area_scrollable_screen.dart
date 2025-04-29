import 'package:flutter/material.dart';

class SafeAreaScrollableScreen extends StatelessWidget {
  const SafeAreaScrollableScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: child,
        ),
      ),
    );
  }
}
