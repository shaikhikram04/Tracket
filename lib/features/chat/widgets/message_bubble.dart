import 'package:flutter/material.dart';
import 'package:tracket/features/chat/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final color = message.isMe ? const Color(0xFFA5D6A7) : Colors.white;

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: message.imageUrl != null
            ? Image.network(message.imageUrl!)
            : Text(
                message.text ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .apply(color: Colors.black),
              ),
      ),
    );
  }
}
