import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
        ),
        child: const Row(
          children: [
            Icon(Icons.emoji_emotions, color: Colors.grey),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Type a message",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Color(0xFF1B5E20),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
