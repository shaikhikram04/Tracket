class TeamRequestStatus {
  final int sendRequest;
  final int pendingRequest;

  const TeamRequestStatus({
    this.sendRequest = 0,
    this.pendingRequest = 0,
  });

  Map<String, dynamic> toJson() => {
        'sendRequest': sendRequest,
        'pendingRequest': pendingRequest,
      };

  factory TeamRequestStatus.fromJson(Map<String, dynamic> json) {
    return TeamRequestStatus(
      sendRequest: json['sendRequest'] ?? 0,
      pendingRequest: json['pendingRequest'] ?? 0,
    );
  }

  TeamRequestStatus copyWith({
    int? sendRequest,
    int? pendingRequest,
  }) {
    return TeamRequestStatus(
      sendRequest: sendRequest ?? this.sendRequest,
      pendingRequest: pendingRequest ?? this.pendingRequest,
    );
  }
}
