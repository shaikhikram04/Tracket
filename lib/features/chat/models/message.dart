import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  const Message(
      {required this.messageId,
      required this.sender,
      required this.receiver,
      required this.message,
      required this.mediaUrl,
      required this.timestamp});

  final String messageId;
  final String sender;
  final String receiver;
  final String message;
  final String mediaUrl;
  final Timestamp timestamp;

  Map<String, dynamic> toMap() => {
        'messageId': messageId,
        'sender': sender,
        'receiver': receiver,
        'message': message,
        'mediaUrl': mediaUrl,
        'timestamp': timestamp,
      };

  static Message fromMap(Map<String, dynamic> messageMap) {
    return Message(
      messageId: messageMap['messageId'],
      sender: messageMap['sender'],
      receiver: messageMap['receiver'],
      message: messageMap['message'],
      mediaUrl: messageMap['mediaUrl'],
      timestamp: messageMap['timestamp'],
    );
  }
}
