import 'package:cloud_firestore/cloud_firestore.dart';

enum RequestType {
  addPlayer,
  joinTeam,
}

class Request {
  Request({
    required this.id,
    required this.from,
    required this.to,
    required this.type,
    required this.requestedAt,
    required this.senderPayload,
    required this.receiverPayload,
  });

  final String id;
  final String from;
  final String to;
  final RequestType type;
  final Map<String, dynamic> senderPayload;
  final Map<String, dynamic> receiverPayload;
  final Timestamp requestedAt;

  Map<String, dynamic> get toJson => {
        'id': id,
        'from': from,
        'to': to,
        'type': type.name,
        'senderPayload': senderPayload,
        'receiverPayload': receiverPayload,
        'requestedAt': requestedAt,
      };

  static Request fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      type: RequestType.values.firstWhere(
        (element) => element.name == json['type'],
      ),
      senderPayload: json['senderPayload'] as Map<String, dynamic>,
      receiverPayload: json['receiverPayload'] as Map<String, dynamic>,
      requestedAt: json['requestedAt'] as Timestamp,
    );
  }
}
