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
    required this.payload,
    required this.requestedAt,
  });

  final String id;
  final String from;
  final String to;
  final RequestType type;
  final Map<String, dynamic> payload;
  final DateTime requestedAt;
}
