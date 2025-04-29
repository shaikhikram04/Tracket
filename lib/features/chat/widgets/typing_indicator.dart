import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16.0, bottom: 4.0),
      child: Row(
        children: [
          Text("User is typing...", style: TextStyle(color: Colors.grey)),
          // You can add animated dots here
        ],
      ),
    );
  }
}
