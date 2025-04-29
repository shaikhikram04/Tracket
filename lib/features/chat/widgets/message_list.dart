import 'package:flutter/material.dart';
import 'package:tracket/features/chat/models/message_model.dart';
import 'package:tracket/features/chat/widgets/message_bubble.dart';

class MessageList extends StatelessWidget {
  final List<MessageModel> messages = [
    MessageModel(text: "Hi!", isMe: false),
    MessageModel(text: "Hello!", isMe: true),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) => MessageBubble(message: messages[index]),
    );
  }
}
